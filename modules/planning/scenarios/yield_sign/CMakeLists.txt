add_library(yield_sign_scenario SHARED
    yield_sign_scenario.cc
    stage_approach.cc
    stage_creep.cc
    proto/yield_sign.pb.cc
)

target_link_libraries(yield_sign_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS yield_sign_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
