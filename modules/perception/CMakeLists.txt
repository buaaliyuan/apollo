# ============================================================================
# modules/perception/CMakeLists.txt
# The perception module is massive with ~30 sub-modules.
# We build perception/common first, then each sub-module as a component.
# ============================================================================

# GPU platform defines used by perception code (#if GPU_PLATFORM == NVIDIA/AMD)
# In Bazel: NVIDIA=0, AMD=1, GPU_PLATFORM=NVIDIA(0) for NVIDIA GPU
# Without GPU: set values so neither branch matches
if(NOT APOLLO_USE_GPU)
    add_compile_definitions(NVIDIA=1 AMD=2 GPU_PLATFORM=0)
    # Provide CUDA type stubs so headers that reference them compile without GPU
    add_compile_options("-DcudaStream_t=void*" "-DcublasHandle_t=void*")
else()
    add_compile_definitions(NVIDIA=0 AMD=1 GPU_PLATFORM=0)  # NVIDIA by default
endif()

# ── Perception common protos ──
file(GLOB _perception_common_protos common/proto/*.proto)
foreach(_proto ${_perception_common_protos})
    get_filename_component(_proto_name ${_proto} NAME_WE)
    set(_proto_deps "")
    # Some protos have deps on common_msgs
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

# ── Nested protos in perception common sub-directories ──
apollo_proto_library(
    NAME perception_object_template_meta_schema_cc_proto
    SRCS common/camera/common/proto/object_template_meta_schema.proto
)

apollo_proto_library(
    NAME perception_ground_service_config_cc_proto
    SRCS common/lidar/scene_manager/ground_service/proto/ground_service_config.proto
)

apollo_proto_library(
    NAME perception_roi_service_cc_proto
    SRCS common/lidar/scene_manager/roi_service/proto/roi_service.proto
)

apollo_proto_library(
    NAME perception_scene_manager_config_cc_proto
    SRCS common/lidar/scene_manager/proto/scene_manager_config.proto
)

# ── perception_gflags ──
apollo_cc_library(
    NAME perception_gflags
    SRCS common/perception_gflags.cc
    HDRS common/perception_gflags.h
    DEPS gflags
    COPTS -DMODULE_NAME="perception"
)

# ── perception_common_util ──
apollo_cc_library(
    NAME perception_common_util
    SRCS common/util.cc
    HDRS common/util.h
    DEPS cyber
    COPTS -DMODULE_NAME="perception"
)

# ── perception common/base (large foundational library) ──
file(GLOB _perception_base_srcs common/base/*.cc)
list(FILTER _perception_base_srcs EXCLUDE REGEX ".*_test\\.cc$")
file(GLOB _perception_base_hdrs common/base/*.h)

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
file(GLOB_RECURSE _perception_algo_srcs common/algorithm/*.cc)
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
    COPTS -DMODULE_NAME="perception" -msse4.1
)

# ── perception common/camera ──
file(GLOB_RECURSE _perception_camera_common_srcs common/camera/*.cc)
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
    COPTS -DMODULE_NAME="perception"
)

# ── perception common/inference ──
file(GLOB_RECURSE _perception_inference_srcs common/inference/*.cc)
list(FILTER _perception_inference_srcs EXCLUDE REGEX ".*_test\\.cc$")
# Remove CUDA/libtorch/onnx-specific files if no GPU
if(NOT APOLLO_USE_GPU)
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
    COPTS -DMODULE_NAME="perception"
)

# ── perception common/lib ──
file(GLOB_RECURSE _perception_lib_srcs common/lib/*.cc)
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
file(GLOB_RECURSE _perception_lidar_common_srcs common/lidar/*.cc)
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
file(GLOB_RECURSE _perception_hdmap_srcs common/hdmap/*.cc)
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
file(GLOB_RECURSE _perception_radar_common_srcs common/radar/*.cc)
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
file(GLOB_RECURSE _perception_onboard_srcs common/onboard/*.cc)
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

# ── Helper macro for perception sub-module components ──
macro(perception_submodule _name)
    cmake_parse_arguments(_PSM "" "" "EXTRA_DEPS;EXTRA_PROTOS" ${ARGN})

    # Collect sub-module's protos (recursively, as they may be deeply nested)
    file(GLOB_RECURSE _sm_protos "${CMAKE_CURRENT_SOURCE_DIR}/${_name}/*.proto")
    list(REMOVE_DUPLICATES _sm_protos)
    if(_sm_protos)
        # Collect all common perception protos as potential dependencies
        set(_common_perception_proto_deps "")
        file(GLOB _cp_protos "${CMAKE_CURRENT_SOURCE_DIR}/common/proto/*.proto")
        foreach(_cp ${_cp_protos})
            get_filename_component(_cpn ${_cp} NAME_WE)
            list(APPEND _common_perception_proto_deps perception_${_cpn}_cc_proto)
        endforeach()
        # Track generated proto targets for this sub-module
        set(_sm_proto_deps_generated "")
        foreach(_p ${_sm_protos})
            get_filename_component(_pn ${_p} NAME_WE)
            # Use relative path to create unique target name
            file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}/${_name}" "${_p}")
            string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
            string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
            set(_proto_target_name "perception_${_name}_${_rel_safe}_cc_proto")
            apollo_proto_library(
                NAME ${_proto_target_name}
                SRCS ${_p}
                DEPS ${_common_perception_proto_deps} ${_PSM_EXTRA_PROTOS}
            )
            list(APPEND _sm_proto_deps_generated ${_proto_target_name})
        endforeach()
    endif()

    # Collect all .cc files
    file(GLOB_RECURSE _sm_srcs "${CMAKE_CURRENT_SOURCE_DIR}/${_name}/*.cc")
    list(FILTER _sm_srcs EXCLUDE REGEX ".*_test\\.cc$")
    list(FILTER _sm_srcs EXCLUDE REGEX ".*/test/.*")
    list(FILTER _sm_srcs EXCLUDE REGEX ".*/tools/.*")
    list(FILTER _sm_srcs EXCLUDE REGEX ".*/testdata/.*")

    # Exclude CUDA-dependent source files when GPU is not available
    if(NOT GPU_PLATFORM)
        # Camera tracking
        list(FILTER _sm_srcs EXCLUDE REGEX ".*project_feature\\.cc$")
        # Lane detection CUDA detectors
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/darkSCNN/.*\\.cc$")
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/denseline/.*\\.cc$")
        # Camera detection CUDA detectors
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/detector/yolo/.*\\.cc$")
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/detector/yolox3d/.*\\.cc$")
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/detector/smoke/.*\\.cc$")
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/detector/caddn/.*\\.cc$")
        # Lidar detection CUDA detectors
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/detector/center_point_detection/.*\\.cc$")
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/detector/cnn_segmentation/.*\\.cc$")
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/detector/point_pillars_detection/.*\\.cc$")
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/detector/mask_pillars_detection/.*\\.cc$")
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/detector/cpdet/.*\\.cc$")
        # Traffic light CUDA detectors/recognizers
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/caffe_recognizer/.*\\.cc$")
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/caffe_detection/.*\\.cc$")
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/yolox_detection/.*\\.cc$")
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/efficient_net/.*\\.cc$")
        # Radar4D CUDA detectors
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/radar4d_detection/.*/point_pillars.*\\.cc$")
        # Pointcloud CUDA parsers
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/pointwise_unet/.*\\.cc$")
        # Plugin CUDA files
        list(FILTER _sm_srcs EXCLUDE REGEX ".*gpu_down_sample\\.cc$")
        list(FILTER _sm_srcs EXCLUDE REGEX ".*onnx_multi_batch_infer\\.cc$")
        # Torch-dependent files (no libtorch available)
        list(FILTER _sm_srcs EXCLUDE REGEX ".*/semantic_map/evaluator_manager\\.cc$")
    endif()

    if(_sm_srcs)
        # Use proto targets generated above
        set(_sm_proto_deps ${_sm_proto_deps_generated})

        # Create component target
        string(REPLACE "/" "_" _safe_name "${_name}")
        apollo_cc_library(
            NAME apollo_perception_${_safe_name}
            SRCS ${_sm_srcs}
            DEPS
                cyber
                apollo_perception_common_base
                apollo_perception_common_algorithm
                apollo_perception_common_camera
                apollo_perception_common_inference
                apollo_perception_common_lib
                apollo_perception_common_lidar
                apollo_perception_common_hdmap
                apollo_perception_common_radar
                apollo_perception_common_onboard
                perception_gflags
                ${_sm_proto_deps}
                ${_PSM_EXTRA_DEPS}
                # Common msg protos
                perception_obstacle_cc_proto
                perception_camera_cc_proto
                traffic_light_detection_cc_proto
                header_cc_proto
                geometry_cc_proto
                pointcloud_cc_proto
                sensor_image_cc_proto
                pcl
                eigen
                yaml-cpp
                absl
            COPTS -DMODULE_NAME="perception"
        )

        # Build as a component .so if there's a *_component.cc
        file(GLOB _sm_comp_srcs "${CMAKE_CURRENT_SOURCE_DIR}/${_name}/*_component.cc")
        if(_sm_comp_srcs)
            apollo_component(
                NAME lib${_safe_name}_component.so
                SRCS ${_sm_comp_srcs}
                DEPS apollo_perception_${_safe_name}
                COPTS -DMODULE_NAME="perception"
            )
        endif()
    endif()
endmacro()

# ── Build all perception sub-modules ──
set(_PERCEPTION_SUBMODULES
    lidar_detection
    lidar_detection_filter
    lidar_tracking
    lidar_output
    lidar_segmentation
    lidar_cpdet_detection
    camera_detection_single_stage
    camera_detection_multi_stage
    camera_detection_bev
    camera_location_estimation
    camera_location_refinement
    camera_tracking
    multi_sensor_fusion
    radar_detection
    radar4d_detection
    lane_detection
    traffic_light_detection
    traffic_light_recognition
    traffic_light_region_proposal
    traffic_light_tracking
    pointcloud_preprocess
    pointcloud_ground_detection
    pointcloud_map_based_roi
    pointcloud_motion
    pointcloud_semantics
    motion_service
    msg_adapter
    barrier_recognition
)

foreach(_sm ${_PERCEPTION_SUBMODULES})
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${_sm}")
        perception_submodule(${_sm})
    endif()
endforeach()
