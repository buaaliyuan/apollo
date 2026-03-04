add_library(free_space_scenario SHARED
    free_space_scenario.cc
    stage_free_space.cc
    proto/free_space_scenario.pb.cc
)

target_link_libraries(free_space_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS free_space_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
