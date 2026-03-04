add_library(park_and_go_scenario SHARED
    park_and_go_scenario.cc
    stage_adjust.cc
    stage_check.cc
    stage_cruise.cc
    stage_pre_cruise.cc
    util.cc
    proto/park_and_go.pb.cc
)

target_link_libraries(park_and_go_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS park_and_go_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
