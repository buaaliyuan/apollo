add_library(stop_sign_unprotected_scenario SHARED
    stop_sign_unprotected_scenario.cc
    stage_pre_stop.cc
    stage_stop.cc
    stage_creep.cc
    stage_intersection_cruise.cc
    proto/stop_sign_unprotected.pb.cc
)

target_link_libraries(stop_sign_unprotected_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS stop_sign_unprotected_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
