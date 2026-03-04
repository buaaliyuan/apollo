add_library(rtk_replay_planner SHARED
    rtk_replay_planner.cc
)

target_link_libraries(rtk_replay_planner PUBLIC
    cyber
    planning_base
)

install(TARGETS rtk_replay_planner
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)