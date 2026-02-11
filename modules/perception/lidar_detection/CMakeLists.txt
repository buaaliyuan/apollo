# ============================================================================
# modules/perception/lidar_detection/CMakeLists.txt
# Component: liblidar_detection_component.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _lidar_det_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_lidar_det_protos})
    get_filename_component(_proto_name ${_proto} NAME_WE)
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    set(_proto_target "perception_lidar_detection_${_rel_safe}_cc_proto")
    apollo_proto_library(
        NAME ${_proto_target}
        SRCS ${_proto}
        DEPS perception_perception_config_schema_cc_proto
    )
endforeach()

# ── CUDA libraries (GPU only) ──
if(APOLLO_USE_GPU)
    file(GLOB _pp_cu_srcs
        detector/point_pillars_detection/*.cu
        detector/cnn_segmentation/*.cu
    )
    if(_pp_cu_srcs)
        apollo_cc_library(
            NAME lidar_detection_cuda
            SRCS ${_pp_cu_srcs}
            DEPS
                apollo_perception_common_base
                ${CUDA_LIBRARIES}
                gtest_headers
            COPTS -DMODULE_NAME="perception"
        )
        # Ensure bundled Eigen 3.3.7 (CUDA 11 compatible) is searched BEFORE
        # system Eigen 3.3.4 (which has broken math_functions.hpp include)
        if(TARGET lidar_detection_cuda AND EIGEN3_INCLUDE_DIR)
            target_include_directories(lidar_detection_cuda BEFORE PRIVATE ${EIGEN3_INCLUDE_DIR})
        endif()
    endif()
endif()

# ── Main library ──
set(_lidar_det_srcs
    detector/center_point_detection/center_point_detection.cc
    detector/cnn_segmentation/cnn_segmentation.cc
    detector/cnn_segmentation/feature_generator.cc
    detector/cnn_segmentation/spp_engine/spp_cluster_list.cc
    detector/cnn_segmentation/spp_engine/spp_engine.cc
    detector/cnn_segmentation/spp_engine/spp_label_image.cc
    detector/cnn_segmentation/spp_engine/spp_pool_types.cc
    detector/cnn_segmentation/spp_engine/spp_seg_cc_2d.cc
    detector/cnn_segmentation/spp_engine/spp_struct.cc
    detector/mask_pillars_detection/mask_pillars_detection.cc
    detector/point_pillars_detection/point_pillars.cc
    detector/point_pillars_detection/point_pillars_detection.cc
    detector/point_pillars_detection/preprocess_points.cc
)

# Filter GPU-only sources when no GPU
if(NOT APOLLO_USE_GPU)
    set(_lidar_det_srcs "")
    # Only include non-GPU sources if any exist
    file(GLOB_RECURSE _lidar_det_srcs_all "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
    list(FILTER _lidar_det_srcs_all EXCLUDE REGEX ".*_test\\.cc$")
    list(FILTER _lidar_det_srcs_all EXCLUDE REGEX ".*_component\\.cc$")
    list(FILTER _lidar_det_srcs_all EXCLUDE REGEX ".*/detector/center_point_detection/.*\\.cc$")
    list(FILTER _lidar_det_srcs_all EXCLUDE REGEX ".*/detector/cnn_segmentation/.*\\.cc$")
    list(FILTER _lidar_det_srcs_all EXCLUDE REGEX ".*/detector/point_pillars_detection/.*\\.cc$")
    list(FILTER _lidar_det_srcs_all EXCLUDE REGEX ".*/detector/mask_pillars_detection/.*\\.cc$")
    set(_lidar_det_srcs ${_lidar_det_srcs_all})
endif()

set(_lidar_det_gpu_deps)
if(APOLLO_USE_GPU)
    if(TARGET lidar_detection_cuda)
        list(APPEND _lidar_det_gpu_deps lidar_detection_cuda)
    endif()
    list(APPEND _lidar_det_gpu_deps ${CUDA_LIBRARIES})
    if(TARGET tensorrt)
        list(APPEND _lidar_det_gpu_deps tensorrt)
    endif()
    if(TARGET paddle_inference)
        list(APPEND _lidar_det_gpu_deps paddle_inference)
    endif()
    if(Torch_FOUND)
        list(APPEND _lidar_det_gpu_deps ${TORCH_LIBRARIES})
    endif()
endif()

# Collect all proto targets for this submodule
set(_lidar_det_proto_deps)
file(GLOB_RECURSE _ld_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_p ${_ld_protos})
    get_filename_component(_pn ${_p} NAME_WE)
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_p}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _lidar_det_proto_deps "perception_lidar_detection_${_rs}_cc_proto")
endforeach()

if(_lidar_det_srcs)
    apollo_cc_library(
        NAME apollo_perception_lidar_detection
        SRCS ${_lidar_det_srcs}
        DEPS
            cyber
            apollo_perception_common_base
            apollo_perception_common_algorithm
            apollo_perception_common_inference
            apollo_perception_common_lib
            apollo_perception_common_lidar
            apollo_perception_common_onboard
            apollo_perception_common_interface
            perception_gflags
            perception_common_util
            perception_perception_config_schema_cc_proto
            ${_lidar_det_proto_deps}
            absl
            eigen
            pcl
            ${_lidar_det_gpu_deps}
        COPTS -DMODULE_NAME="perception"
    )
else()
    # Empty placeholder when no sources
    apollo_cc_library(
        NAME apollo_perception_lidar_detection
        INTERFACE
        DEPS
            cyber
            apollo_perception_common_onboard
    )
endif()

# ── Component .so ──
apollo_component(
    NAME liblidar_detection_component.so
    SRCS lidar_detection_component.cc
    HDRS lidar_detection_component.h
    DEPS
        apollo_perception_lidar_detection
        cyber
        apollo_perception_common_onboard
        ${_lidar_det_proto_deps}
    COPTS -DMODULE_NAME="perception"
    LINKOPTS -lleveldb
)
