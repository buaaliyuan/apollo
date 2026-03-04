add_library(lane_follow_park_scenario SHARED
    lane_follow_park_scenario.cc
    lane_follow_park_stage.cc
    proto/lane_follow_park_scenario.pb.cc
)

target_link_libraries(lane_follow_park_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS lane_follow_park_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
