add_library(routing_component SHARED)
target_sources(routing_component
  PRIVATE
    routing_component.cc
    common/routing_gflags.cc
    core/black_list_range_generator.cc
    core/navigator.cc
    core/result_generator.cc
    graph/node_with_range.cc
    graph/sub_topo_graph.cc
    graph/topo_graph.cc
    graph/topo_node.cc
    graph/topo_range.cc
    graph/topo_range_manager.cc
    graph/topo_test_utils.cc
    routing.cc
    strategy/a_star_strategy.cc
    topo_creator/edge_creator.cc
    topo_creator/graph_creator.cc
    topo_creator/node_creator.cc
    proto/routing_config.pb.cc
    proto/topo_graph.pb.cc
)

target_link_libraries(routing_component
  PRIVATE
    cyber
    modules_common
    msg_proto
    Boost::filesystem
    apollo_map
)

target_compile_definitions(routing_component
  PRIVATE
    MODULE_NAME="routing"
)
install(TARGETS routing_component
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)

add_executable(topo_creator topo_creator/topo_creator.cc)
target_link_libraries(topo_creator
PRIVATE
    routing_component
    apollo_map
)

target_compile_definitions(topo_creator
  PRIVATE
    MODULE_NAME="routing"
)

install(TARGETS topo_creator
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)