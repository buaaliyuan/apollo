add_library(piecewise_jerk_speed_nonlinear SHARED
    piecewise_jerk_speed_nonlinear_optimizer.cc
    piecewise_jerk_speed_nonlinear_ipopt_interface.cc
    proto/piecewise_jerk_speed_nonlinear.pb.cc
)

target_link_libraries(piecewise_jerk_speed_nonlinear PUBLIC
    cyber
    planning_base
)

install(TARGETS piecewise_jerk_speed_nonlinear
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
