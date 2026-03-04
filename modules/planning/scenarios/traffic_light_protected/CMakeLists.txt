add_library(traffic_light_protected_scenario SHARED
    traffic_light_protected_scenario.cc
    stage_approach.cc
    stage_intersection_cruise.cc
    proto/traffic_light_protected.pb.cc
)

target_link_libraries(traffic_light_protected_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS traffic_light_protected_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
