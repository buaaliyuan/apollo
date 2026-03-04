add_library(public_road_planner SHARED
    public_road_planner.cc
    scenario_manager.cc
    proto/planner_config.pb.cc
)

target_link_libraries(
    public_road_planner PUBLIC
    cyber
    planning_base
)

install(TARGETS public_road_planner
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)