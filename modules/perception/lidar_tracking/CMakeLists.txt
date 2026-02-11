# ============================================================================
# modules/perception/lidar_tracking/CMakeLists.txt
# Component: liblidar_tracking_component.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _lt_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_lt_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    set(_proto_target "perception_lidar_tracking_${_rel_safe}_cc_proto")
    apollo_proto_library(
        NAME ${_proto_target}
        SRCS ${_proto}
    )
endforeach()

# ── Main library ──
file(GLOB_RECURSE _lt_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER _lt_srcs EXCLUDE REGEX ".*_test\\.cc$")
list(FILTER _lt_srcs EXCLUDE REGEX ".*_component\\.cc$")

# Collect proto targets
set(_lt_proto_deps)
foreach(_proto ${_lt_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _lt_proto_deps "perception_lidar_tracking_${_rs}_cc_proto")
endforeach()

apollo_cc_library(
    NAME apollo_perception_lidar_tracking
    SRCS ${_lt_srcs}
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        apollo_perception_common_lib
        apollo_perception_common_lidar
        apollo_perception_common_onboard
        perception_gflags
        perception_common_util
        ${_lt_proto_deps}
        eigen
    COPTS -DMODULE_NAME="perception"
)

# ── Component .so ──
apollo_component(
    NAME liblidar_tracking_component.so
    SRCS lidar_tracking_component.cc
    HDRS lidar_tracking_component.h
    DEPS
        apollo_perception_lidar_tracking
        cyber
        apollo_perception_common_onboard
    COPTS -DMODULE_NAME="perception"
    LINKOPTS -lleveldb
)
