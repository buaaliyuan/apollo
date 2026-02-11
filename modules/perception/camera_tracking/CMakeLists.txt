# ============================================================================
# modules/perception/camera_tracking/CMakeLists.txt
# Component: libcamera_tracking_component_camera.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _ct_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_ct_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_camera_tracking_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_ct_proto_deps)
foreach(_proto ${_ct_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _ct_proto_deps "perception_camera_tracking_${_rs}_cc_proto")
endforeach()

# ── Main library ──
set(_ct_srcs
    base/obstacle_reference.cc
    base/target.cc
    common/kalman_filter.cc
    common/similar.cc
    feature_extract/external_feature_extractor.cc
    feature_extract/tracking_feat_extractor.cc
    tracking/omt_obstacle_tracker.cc
)

# project_feature.cc requires CUDA
if(APOLLO_USE_GPU)
    list(APPEND _ct_srcs feature_extract/project_feature.cc)
endif()

set(_ct_gpu_deps)
if(APOLLO_USE_GPU)
    list(APPEND _ct_gpu_deps ${CUDA_LIBRARIES})
endif()

apollo_cc_library(
    NAME apollo_perception_camera_tracking
    SRCS ${_ct_srcs}
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        apollo_perception_common_camera
        apollo_perception_common_inference
        apollo_perception_common_lib
        apollo_perception_common_onboard
        perception_common_util
        perception_obstacle_cc_proto
        ${_ct_proto_deps}
        Boost::headers
        eigen
        ${_ct_gpu_deps}
    COPTS -DMODULE_NAME="perception"
)

# ── Component .so ──
apollo_component(
    NAME libcamera_tracking_component_camera.so
    SRCS camera_tracking_component.cc
    HDRS camera_tracking_component.h
    DEPS
        apollo_perception_camera_tracking
        cyber
        apollo_perception_common_algorithm
        apollo_perception_common_onboard
        perception_common_util
        perception_obstacle_cc_proto
        ${_ct_proto_deps}
    COPTS -DMODULE_NAME="perception"
)
