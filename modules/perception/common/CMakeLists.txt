# ============================================================================
# modules/perception/common/CMakeLists.txt
# Perception common libraries: base, algorithm, camera, inference, lib, lidar,
# hdmap, radar, onboard, and utility/gflags targets.
# ============================================================================

# ── Perception common protos ──
file(GLOB _perception_common_protos proto/*.proto)
foreach(_proto ${_perception_common_protos})
    get_filename_component(_proto_name ${_proto} NAME_WE)
    set(_proto_deps "")
    if(_proto_name STREQUAL "motion_service")
        set(_proto_deps header_cc_proto)
    endif()
    if(_proto_name STREQUAL "perception_ultrasonic")
        set(_proto_deps header_cc_proto geometry_cc_proto)
    endif()
    apollo_proto_library(
        NAME perception_${_proto_name}_cc_proto
        SRCS ${_proto}
        DEPS ${_proto_deps}
    )
endforeach()

# ── Nested protos ──
apollo_proto_library(
    NAME perception_object_template_meta_schema_cc_proto
    SRCS camera/common/proto/object_template_meta_schema.proto
)

apollo_proto_library(
    NAME perception_ground_service_config_cc_proto
    SRCS lidar/scene_manager/ground_service/proto/ground_service_config.proto
)

apollo_proto_library(
    NAME perception_roi_service_cc_proto
    SRCS lidar/scene_manager/roi_service/proto/roi_service.proto
)

apollo_proto_library(
    NAME perception_scene_manager_config_cc_proto
    SRCS lidar/scene_manager/proto/scene_manager_config.proto
)

# ── perception_gflags ──
apollo_cc_library(
    NAME perception_gflags
    SRCS perception_gflags.cc
    HDRS perception_gflags.h
    DEPS gflags
    COPTS -DMODULE_NAME="perception"
)

# ── perception_common_util ──
apollo_cc_library(
    NAME perception_common_util
    SRCS util.cc
    HDRS util.h
    DEPS cyber
    COPTS -DMODULE_NAME="perception"
)

# ── perception common/base ──
file(GLOB _perception_base_srcs base/*.cc)
list(FILTER _perception_base_srcs EXCLUDE REGEX ".*_test\\.cc$")
file(GLOB _perception_base_hdrs base/*.h)

apollo_cc_library(
    NAME apollo_perception_common_base
    SRCS ${_perception_base_srcs}
    HDRS ${_perception_base_hdrs}
    DEPS
        cyber
        perception_gflags
        perception_common_util
        eigen
        absl
        Boost::headers
        ${OpenCV_LIBS}
    COPTS -DMODULE_NAME="perception"
)

# ── perception common/algorithm ──
file(GLOB_RECURSE _perception_algo_srcs algorithm/*.cc)
list(FILTER _perception_algo_srcs EXCLUDE REGEX ".*_test\\.cc$")

apollo_cc_library(
    NAME apollo_perception_common_algorithm
    SRCS ${_perception_algo_srcs}
    DEPS
        cyber
        apollo_perception_common_base
        perception_gflags
        perception_sensor_meta_schema_cc_proto
        eigen
        yaml-cpp
        Boost::filesystem
    COPTS -DMODULE_NAME="perception" -msse4.1
)

# ── perception common/camera ──
file(GLOB_RECURSE _perception_camera_common_srcs camera/*.cc)
list(FILTER _perception_camera_common_srcs EXCLUDE REGEX ".*_test\\.cc$")
if(NOT APOLLO_USE_GPU)
    list(FILTER _perception_camera_common_srcs EXCLUDE REGEX ".*data_provider\\.cc$")
    list(FILTER _perception_camera_common_srcs EXCLUDE REGEX ".*image_data_operations\\.cc$")
    list(FILTER _perception_camera_common_srcs EXCLUDE REGEX ".*undistortion_handler\\.cc$")
endif()

apollo_cc_library(
    NAME apollo_perception_common_camera
    SRCS ${_perception_camera_common_srcs}
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        perception_gflags
        perception_model_info_cc_proto
        perception_object_template_meta_schema_cc_proto
        eigen
        yaml-cpp
        $<$<BOOL:${APOLLO_USE_GPU}>:npp>
    COPTS -DMODULE_NAME="perception"
)

# ── perception common/inference ──
file(GLOB_RECURSE _perception_inference_srcs inference/*.cc)
list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*_test\\.cc$")
if(NOT APOLLO_USE_GPU)
    message(STATUS "== ${CMAKE_CURRENT_SOURCE_DIR}: GPU support is disabled, excluding GPU backends")
    list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*tensorrt.*\\.cc$")
    list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*paddlepaddle.*\\.cc$")
    list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*migraphx.*\\.cc$")
    list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*cal_table_generator.*\\.cc$")
    list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*denseline_sample.*\\.cc$")
    list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*lane_sample.*\\.cc$")
    list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*yolo_sample.*\\.cc$")
    list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*libtorch.*\\.cc$")
    list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*onnx.*\\.cc$")
    list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*torch_net.*\\.cc$")
    list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*inference_factory\\.cc$")
    list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*inference\\.cc$")
else()
    if(NOT TARGET tensorrt)
        message(STATUS "perception: TensorRT not found, excluding tensorrt backend")
        list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*tensorrt.*\\.cc$")
        list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*cal_table_generator.*\\.cc$")
        list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*denseline_sample.*\\.cc$")
        list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*lane_sample.*\\.cc$")
        list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*yolo_sample.*\\.cc$")
    endif()
    if(NOT TARGET paddle_inference)
        message(STATUS "perception: PaddlePaddle not found, excluding paddle backend")
        list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*paddlepaddle.*\\.cc$")
    endif()
    find_path(_migraphx_inc migraphx/argument.hpp)
    if(NOT _migraphx_inc)
        message(STATUS "perception: MIGraphX not found, excluding migraphx backend")
        list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*migraphx.*\\.cc$")
    endif()
    if(NOT Torch_FOUND)
        message(STATUS "perception: LibTorch not found, excluding libtorch/onnx backends")
        list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*libtorch.*\\.cc$")
        list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*onnx.*\\.cc$")
        list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*torch_net.*\\.cc$")
        list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*inference_factory\\.cc$")
        list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*inference\\.cc$")
    endif()
endif()

set(_inference_gpu_deps)
set(_inference_gpu_incdirs)
if(APOLLO_USE_GPU)
    if(Torch_FOUND)
        list(APPEND _inference_gpu_deps ${TORCH_LIBRARIES})
        list(APPEND _inference_gpu_incdirs ${TORCH_INCLUDE_DIRS})
        find_package(PythonLibs QUIET)
        if(PYTHONLIBS_FOUND)
            list(APPEND _inference_gpu_incdirs ${PYTHON_INCLUDE_DIRS})
        endif()
    endif()
    if(TARGET tensorrt)
        list(APPEND _inference_gpu_deps tensorrt)
    endif()
    if(TARGET cudnn)
        list(APPEND _inference_gpu_deps cudnn)
    endif()
    if(TARGET paddle_inference)
        list(APPEND _inference_gpu_deps paddle_inference)
    endif()
    if(TARGET npp)
        list(APPEND _inference_gpu_deps npp)
    endif()
    list(APPEND _inference_gpu_deps ${CUDA_LIBRARIES} ${CUDA_CUBLAS_LIBRARIES})
    list(APPEND _inference_gpu_incdirs ${CUDA_INCLUDE_DIRS})
endif()

apollo_cc_library(
    NAME apollo_perception_common_inference
    SRCS ${_perception_inference_srcs}
    DEPS
        cyber
        apollo_perception_common_base
        perception_gflags
        perception_model_info_cc_proto
        perception_model_process_cc_proto
        perception_rt_cc_proto
        protobuf::libprotobuf
        eigen
        absl
        ${_inference_gpu_deps}
    COPTS -DMODULE_NAME="perception"
)

if(_inference_gpu_incdirs)
    target_include_directories(apollo_perception_common_inference PUBLIC ${_inference_gpu_incdirs})
endif()

# ── perception common/lib ──
file(GLOB_RECURSE _perception_lib_srcs lib/*.cc)
list(FILTER _perception_lib_srcs EXCLUDE REGEX ".*_test\\.cc$")

apollo_cc_library(
    NAME apollo_perception_common_lib
    SRCS ${_perception_lib_srcs}
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        perception_gflags
        perception_perception_config_schema_cc_proto
        yaml-cpp
    COPTS -DMODULE_NAME="perception"
)

# ── perception common/lidar ──
file(GLOB_RECURSE _perception_lidar_common_srcs lidar/*.cc)
list(FILTER _perception_lidar_common_srcs EXCLUDE REGEX ".*_test\\.cc$")

apollo_cc_library(
    NAME apollo_perception_common_lidar
    SRCS ${_perception_lidar_common_srcs}
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        apollo_perception_common_lib
        perception_gflags
        gtest_headers
        pcl
        eigen
        perception_ground_service_config_cc_proto
        perception_roi_service_cc_proto
        perception_scene_manager_config_cc_proto
    COPTS -DMODULE_NAME="perception"
)

# ── perception common/hdmap ──
file(GLOB_RECURSE _perception_hdmap_srcs hdmap/*.cc)
list(FILTER _perception_hdmap_srcs EXCLUDE REGEX ".*_test\\.cc$")

apollo_cc_library(
    NAME apollo_perception_common_hdmap
    SRCS ${_perception_hdmap_srcs}
    DEPS
        cyber
        apollo_perception_common_base
        apollo_map
        perception_gflags
    COPTS -DMODULE_NAME="perception"
)

# ── perception common/radar ──
file(GLOB_RECURSE _perception_radar_common_srcs radar/*.cc)
list(FILTER _perception_radar_common_srcs EXCLUDE REGEX ".*_test\\.cc$")

apollo_cc_library(
    NAME apollo_perception_common_radar
    SRCS ${_perception_radar_common_srcs}
    DEPS
        cyber
        apollo_perception_common_base
        gtest_headers
    COPTS -DMODULE_NAME="perception"
)

# ── perception common/onboard ──
file(GLOB_RECURSE _perception_onboard_srcs onboard/*.cc)
list(FILTER _perception_onboard_srcs EXCLUDE REGEX ".*_test\\.cc$")

apollo_cc_library(
    NAME apollo_perception_common_onboard
    SRCS ${_perception_onboard_srcs}
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        perception_gflags
        perception_obstacle_cc_proto
        perception_camera_cc_proto
        traffic_light_detection_cc_proto
        header_cc_proto
        apollo_transform
    COPTS -DMODULE_NAME="perception"
)

# ── perception common/interface (header-only) ──
apollo_cc_library(
    NAME apollo_perception_common_interface
    SRCS 
        interface/base_obstacle_detector.cc

    HDRS
        interface/base_down_sample.h
        interface/base_obstacle_detector.h
    DEPS
        apollo_perception_common_base
        apollo_perception_common_lib
        apollo_perception_common_lidar
        ${TORCH_LIBRARIES}
    COPTS -DMODULE_NAME="perception"
)
