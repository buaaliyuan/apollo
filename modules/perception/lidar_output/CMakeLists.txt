# ============================================================================
# modules/perception/lidar_output/CMakeLists.txt
# Component: liblidar_output_component.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _lo_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_lo_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_lidar_output_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

# Collect proto targets
set(_lo_proto_deps)
foreach(_proto ${_lo_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _lo_proto_deps "perception_lidar_output_${_rs}_cc_proto")
endforeach()

# ── Component .so (self-contained, no separate library) ──
apollo_component(
    NAME liblidar_output_component.so
    SRCS lidar_output_component.cc
    HDRS lidar_output_component.h
    DEPS
        cyber
        apollo_perception_common_algorithm
        apollo_perception_common_lidar
        apollo_perception_common_onboard
        ${_lo_proto_deps}
        perception_benchmark_cc_proto
        Boost::headers
    COPTS -DMODULE_NAME="perception"
    LINKOPTS -lleveldb
)
