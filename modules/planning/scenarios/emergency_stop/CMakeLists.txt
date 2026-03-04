add_library(emergency_stop_scenario SHARED
    emergency_stop_scenario.cc
    stage_approach.cc
    stage_standby.cc
    proto/emergency_stop.pb.cc
)

target_link_libraries(emergency_stop_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS emergency_stop_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
