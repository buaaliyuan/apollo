# ============================================================================
# modules/perception/multi_sensor_fusion/CMakeLists.txt
# Component: libmulti_sensor_fusion.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _msf_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_msf_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_multi_sensor_fusion_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_msf_proto_deps)
foreach(_proto ${_msf_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _msf_proto_deps "perception_multi_sensor_fusion_${_rs}_cc_proto")
endforeach()

# ── Main library ──
file(GLOB_RECURSE _msf_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER _msf_srcs EXCLUDE REGEX ".*_test\\.cc$")
list(FILTER _msf_srcs EXCLUDE REGEX ".*_component\\.cc$")

apollo_cc_library(
    NAME apollo_perception_multi_sensor_fusion
    SRCS ${_msf_srcs}
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        apollo_perception_common_hdmap
        apollo_perception_common_lib
        apollo_perception_common_onboard
        perception_gflags
        perception_common_util
        ${_msf_proto_deps}
        Boost::headers
        absl
        eigen
    COPTS -DMODULE_NAME="perception"
)

# ── Component .so ──
apollo_component(
    NAME libmulti_sensor_fusion.so
    SRCS multi_sensor_fusion_component.cc
    HDRS multi_sensor_fusion_component.h
    DEPS
        apollo_perception_multi_sensor_fusion
        cyber
        apollo_perception_common_base
        apollo_perception_common_hdmap
        apollo_perception_common_lib
        apollo_perception_common_onboard
        ${_msf_proto_deps}
        eigen
    COPTS -DMODULE_NAME="perception"
)
