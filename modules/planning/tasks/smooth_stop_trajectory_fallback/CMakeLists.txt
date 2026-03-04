add_library(smooth_stop_trajectory_fallback SHARED
    smooth_stop_trajectory_fallback.cc
    util/speed_planner.cc
)

target_link_libraries(smooth_stop_trajectory_fallback PUBLIC
    cyber
    planning_base
)

install(TARGETS smooth_stop_trajectory_fallback
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
