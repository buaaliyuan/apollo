# ============================================================================
# modules/perception/lane_detection/CMakeLists.txt
# Component: liblane_detection.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _ld_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_ld_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_lane_detection_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_ld_proto_deps)
foreach(_proto ${_ld_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _ld_proto_deps "perception_lane_detection_${_rs}_cc_proto")
endforeach()

# ── Main library ──
file(GLOB_RECURSE _ld_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER _ld_srcs EXCLUDE REGEX ".*_test\\.cc$")
list(FILTER _ld_srcs EXCLUDE REGEX ".*_component\\.cc$")

if(NOT APOLLO_USE_GPU)
    list(FILTER _ld_srcs EXCLUDE REGEX ".*/darkSCNN/.*\\.cc$")
    list(FILTER _ld_srcs EXCLUDE REGEX ".*/denseline/.*\\.cc$")
endif()

apollo_cc_library(
    NAME apollo_perception_lane_detection
    SRCS ${_ld_srcs}
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        apollo_perception_common_camera
        apollo_perception_common_inference
        apollo_perception_common_lib
        apollo_perception_common_onboard
        perception_gflags
        perception_common_util
        perception_motion_service_cc_proto
        error_code_cc_proto
        geometry_cc_proto
        header_cc_proto
        perception_camera_cc_proto
        perception_lane_cc_proto
        perception_obstacle_cc_proto
        traffic_light_detection_cc_proto
        sensor_image_cc_proto
        transform_cc_proto
        ${_ld_proto_deps}
        gflags
        eigen
        ${OpenCV_LIBS}
    COPTS -DMODULE_NAME="perception"
)

# ── Component .so ──
apollo_component(
    NAME liblane_detection.so
    SRCS lane_detection_component.cc
    HDRS lane_detection_component.h
    DEPS
        apollo_perception_lane_detection
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        apollo_perception_common_camera
        apollo_perception_common_onboard
        perception_gflags
        perception_common_util
        perception_motion_service_cc_proto
        error_code_cc_proto
        geometry_cc_proto
        header_cc_proto
        perception_camera_cc_proto
        perception_lane_cc_proto
        perception_obstacle_cc_proto
        traffic_light_detection_cc_proto
        sensor_image_cc_proto
        transform_cc_proto
        ${_ld_proto_deps}
        eigen
        ${OpenCV_LIBS}
    COPTS -DMODULE_NAME="perception"
)
