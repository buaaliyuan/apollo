add_library(valet_parking_scenario SHARED
    valet_parking_scenario.cc
    stage_approaching_parking_spot.cc
    stage_parking.cc
    proto/valet_parking.pb.cc
)

target_link_libraries(valet_parking_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS valet_parking_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
