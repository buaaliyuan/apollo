add_library(pull_over_scenario SHARED
    pull_over_scenario.cc
    stage_approach.cc
    stage_retry_approach_parking.cc
    stage_retry_parking.cc
    util.cc
    proto/pull_over.pb.cc
)

target_link_libraries(pull_over_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS pull_over_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
