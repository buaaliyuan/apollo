add_library(emergency_pull_over_scenario SHARED
    emergency_pull_over_scenario.cc
    stage_approach.cc
    stage_slow_down.cc
    stage_standby.cc
    proto/emergency_pull_over.pb.cc
)

target_link_libraries(emergency_pull_over_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS emergency_pull_over_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
