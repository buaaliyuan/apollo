# ============================================================================
# modules/perception/radar_detection/CMakeLists.txt
# Component: libradar_detection.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _rd_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_rd_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_radar_detection_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_rd_proto_deps)
foreach(_proto ${_rd_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _rd_proto_deps "perception_radar_detection_${_rs}_cc_proto")
endforeach()

# ── Main library ──
file(GLOB_RECURSE _rd_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER _rd_srcs EXCLUDE REGEX ".*_test\\.cc$")
list(FILTER _rd_srcs EXCLUDE REGEX ".*_component\\.cc$")

apollo_cc_library(
    NAME apollo_perception_radar_detection
    SRCS ${_rd_srcs}
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        apollo_perception_common_hdmap
        apollo_perception_common_lib
        apollo_perception_common_onboard
        perception_gflags
        perception_common_util
        conti_radar_cc_proto
        ${_rd_proto_deps}
        absl
        eigen
    COPTS -DMODULE_NAME="perception"
)

# ── Component .so ──
apollo_component(
    NAME libradar_detection.so
    SRCS radar_detection_component.cc
    HDRS radar_detection_component.h
    DEPS
        apollo_perception_radar_detection
        cyber
        apollo_perception_common_algorithm
        apollo_perception_common_base
        apollo_perception_common_hdmap
        apollo_perception_common_lib
        apollo_perception_common_onboard
        ${_rd_proto_deps}
    COPTS -DMODULE_NAME="perception"
)
