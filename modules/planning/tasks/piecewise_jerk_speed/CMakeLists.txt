add_library(piecewise_jerk_speed SHARED
    piecewise_jerk_speed_optimizer.cc
    proto/piecewise_jerk_speed.pb.cc
)

target_link_libraries(piecewise_jerk_speed PUBLIC
    cyber
    planning_base
)

install(TARGETS piecewise_jerk_speed
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
