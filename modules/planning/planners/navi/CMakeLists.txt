add_library(navi_planner SHARED
    decider/navi_obstacle_decider.cc
    decider/navi_path_decider.cc
    decider/navi_speed_decider.cc
    decider/navi_speed_ts_graph.cc
    decider/navi_task.cc
    proto/navi_task_config.pb.cc
    proto/planner_config.pb.cc
    navi_planner.cc
)

target_link_libraries(navi_planner PUBLIC
    cyber
    planning_base
)

install(TARGETS navi_planner
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)