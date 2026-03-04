add_library(obstacle_nudge_decider SHARED
    obstacle_nudge_decider.cc
    nudge_calculation.cc
    proto/obstacle_nudge_decider.pb.cc
)

target_link_libraries(obstacle_nudge_decider PUBLIC
    cyber
    planning_base
)

install(TARGETS obstacle_nudge_decider
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
