# ============================================================================
# modules/perception/camera_detection_multi_stage/CMakeLists.txt
# Component: libcamera_detection_multi_stage_component_camera.so
# Requires GPU (CUDA for yolo postprocess)
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _cdms_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_cdms_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_camera_detection_multi_stage_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_cdms_proto_deps)
foreach(_proto ${_cdms_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _cdms_proto_deps "perception_camera_detection_multi_stage_${_rs}_cc_proto")
endforeach()

# ── Main library (GPU-dependent detectors) ──
set(_cdms_srcs)
set(_cdms_gpu_deps)

if(APOLLO_USE_GPU)
    set(_cdms_srcs
        detector/yolo/postprocess.cc
        detector/yolo/yolo_obstacle_detector.cc
        detector/yolo/object_maintainer.cc
        detector/yolox3d/postprocess.cc
        detector/yolox3d/yolox3d_obstacle_detector.cc
    )
    list(APPEND _cdms_gpu_deps ${CUDA_LIBRARIES} ${CUDA_CUBLAS_LIBRARIES})
    if(TARGET tensorrt)
        list(APPEND _cdms_gpu_deps tensorrt)
    endif()
    if(TARGET cudnn)
        list(APPEND _cdms_gpu_deps cudnn)
    endif()
endif()

if(_cdms_srcs)
    apollo_cc_library(
        NAME apollo_perception_camera_detection_multi_stage
        SRCS ${_cdms_srcs}
        DEPS
            cyber
            apollo_perception_common_base
            apollo_perception_common_algorithm
            apollo_perception_common_camera
            apollo_perception_common_inference
            apollo_perception_common_lib
            apollo_perception_common_onboard
            apollo_perception_common_interface
            perception_gflags
            perception_common_util
            perception_model_info_cc_proto
            sensor_image_cc_proto
            ${_cdms_proto_deps}
            protobuf::libprotobuf
            eigen
            ${OpenCV_LIBS}
            ${_cdms_gpu_deps}
        COPTS -DMODULE_NAME="perception"
    )
    if(APOLLO_USE_GPU)
        target_include_directories(apollo_perception_camera_detection_multi_stage
            PUBLIC ${CUDA_INCLUDE_DIRS})
    endif()
else()
    apollo_cc_library(
        NAME apollo_perception_camera_detection_multi_stage
        INTERFACE
        DEPS cyber apollo_perception_common_onboard
    )
endif()

# ── Component .so ──
set(_cdms_comp_gpu_deps)
if(APOLLO_USE_GPU)
    list(APPEND _cdms_comp_gpu_deps ${CUDA_LIBRARIES} ${CUDA_CUBLAS_LIBRARIES})
    if(TARGET tensorrt)
        list(APPEND _cdms_comp_gpu_deps tensorrt)
    endif()
    if(TARGET cudnn)
        list(APPEND _cdms_comp_gpu_deps cudnn)
    endif()
endif()

apollo_component(
    NAME libcamera_detection_multi_stage_component_camera.so
    SRCS camera_detection_multi_stage_component.cc
    HDRS camera_detection_multi_stage_component.h
    DEPS
        apollo_perception_camera_detection_multi_stage
        cyber
        apollo_perception_common_algorithm
        apollo_perception_common_camera
        apollo_perception_common_onboard
        perception_common_util
        perception_model_info_cc_proto
        sensor_image_cc_proto
        ${_cdms_proto_deps}
        ${_cdms_comp_gpu_deps}
    COPTS -DMODULE_NAME="perception"
)
