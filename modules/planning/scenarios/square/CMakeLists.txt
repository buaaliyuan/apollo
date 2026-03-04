add_library(square_scenario SHARED
    square_scenario.cc
    extricate_stage.cc
    square_lane_follow_stage.cc
    proto/square.pb.cc
)

target_link_libraries(square_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS square_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
