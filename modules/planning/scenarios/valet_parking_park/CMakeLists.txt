add_library(valet_parking_park_scenario SHARED
    valet_parking_scenario.cc
    stage_approaching_parking_spot_park.cc
    stage_parking_park.cc
    stage_parking_retry_park.cc
    proto/valet_parking_park.pb.cc
)

target_link_libraries(valet_parking_park_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS valet_parking_park_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
