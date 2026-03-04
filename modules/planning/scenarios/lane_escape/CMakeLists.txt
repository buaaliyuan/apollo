add_library(lane_escape_scenario SHARED
    lane_escape_scenario.cc
    lane_escape_stage.cc
    proto/lane_escape_scenario.pb.cc
)

target_link_libraries(lane_escape_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS lane_escape_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
