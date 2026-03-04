add_library(fast_stop_trajectory_fallback SHARED
    fast_stop_trajectory_fallback.cc
)

target_link_libraries(fast_stop_trajectory_fallback PUBLIC
    cyber
    planning_base
)

install(TARGETS fast_stop_trajectory_fallback
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
