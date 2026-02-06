# ============================================================================
# modules/routing/CMakeLists.txt
# ============================================================================

# ── Proto ──
apollo_proto_library(
    NAME routing_config_cc_proto
    SRCS proto/routing_config.proto
)

apollo_proto_library(
    NAME topo_graph_cc_proto
    SRCS proto/topo_graph.proto
    DEPS map_geometry_cc_proto
)

# ── apollo_routing library ──
file(GLOB_RECURSE _routing_srcs
    common/*.cc
    core/*.cc
    graph/*.cc
    strategy/*.cc
)
list(FILTER _routing_srcs EXCLUDE REGEX ".*_test\\.cc$")

apollo_cc_library(
    NAME apollo_routing
    SRCS ${_routing_srcs}
    DEPS
        cyber
        adapter_gflags
        config_gflags
        monitor_log
        common_util
        # Proto deps
        routing_cc_proto
        routing_config_cc_proto
        topo_graph_cc_proto
        map_lane_cc_proto
        map_id_cc_proto
        geometry_cc_proto
        pnc_point_cc_proto
        # Module deps
        apollo_map
        gflags
        absl
    COPTS -DMODULE_NAME="routing"
)

# ── routing_component ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/routing_component.cc")
    apollo_component(
        NAME librouting_component.so
        SRCS routing_component.cc
        HDRS routing_component.h
        DEPS
            apollo_routing
            cyber
            adapter_gflags
            monitor_log
        COPTS -DMODULE_NAME="routing"
    )
endif()

# ── Binaries ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/topo_creator/topo_creator.cc")
    apollo_cc_binary(
        NAME topo_creator
        SRCS topo_creator/topo_creator.cc
             topo_creator/graph_creator.cc
             topo_creator/edge_creator.cc
             topo_creator/node_creator.cc
        DEPS apollo_routing cyber gflags
    )
endif()

foreach(_tool routing_dump routing_cast routing_tester)
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/tools/${_tool}.cc")
        apollo_cc_binary(
            NAME ${_tool}
            SRCS tools/${_tool}.cc
            DEPS apollo_routing cyber gflags adapter_gflags
                 planning_cc_proto
        )
    endif()
endforeach()
