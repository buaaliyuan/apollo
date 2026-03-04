add_library(path_time_heuristic SHARED
    path_time_heuristic_optimizer.cc
    gridded_path_time_graph.cc
    dp_st_cost.cc
    st_graph_point.cc
    proto/path_time_heuristic.pb.cc
)

target_link_libraries(path_time_heuristic PUBLIC
    cyber
    planning_base
)

install(TARGETS path_time_heuristic
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
