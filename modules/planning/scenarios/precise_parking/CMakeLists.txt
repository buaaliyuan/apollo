add_library(precise_parking_scenario SHARED
    precise_parking_scenario.cc
    stage_approaching_precise_parking.cc
    stage_arrive_parking_spot.cc
    stage_precise_parking.cc
    proto/precise_parking_scenario.pb.cc
)

target_link_libraries(precise_parking_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS precise_parking_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
