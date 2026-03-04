add_library(traffic_light_unprotected_left_turn_scenario SHARED
    traffic_light_unprotected_left_turn_scenario.cc
    stage_approach.cc
    stage_creep.cc
    stage_intersection_cruise.cc
    proto/traffic_light_unprotected_left_turn.pb.cc
)

target_link_libraries(traffic_light_unprotected_left_turn_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS traffic_light_unprotected_left_turn_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
