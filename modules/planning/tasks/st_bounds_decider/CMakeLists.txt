add_library(st_bounds_decider SHARED
    st_bounds_decider.cc
    st_driving_limits.cc
    st_guide_line.cc
    st_obstacles_processor.cc
    proto/st_bounds_decider.pb.cc
)

target_link_libraries(st_bounds_decider PUBLIC
    cyber
    planning_base
)

install(TARGETS st_bounds_decider
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
