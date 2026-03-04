add_library(lane_follow_scenario SHARED
    lane_follow_scenario.cc
    lane_follow_stage.cc
)

target_link_libraries(lane_follow_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS lane_follow_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
