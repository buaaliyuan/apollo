add_library(speed_bounds_decider SHARED
    speed_bounds_decider.cc
    speed_limit_decider.cc
    st_boundary_mapper.cc
    proto/speed_bounds_decider.pb.cc
)

target_link_libraries(speed_bounds_decider PUBLIC
    cyber
    planning_base
)

install(TARGETS speed_bounds_decider
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
