add_library(open_space_trajectory_post_process SHARED
    open_space_trajectory_post_process.cc
    proto/open_space_trajectory_post_process.pb.cc
)

target_link_libraries(open_space_trajectory_post_process PUBLIC
    cyber
    planning_base
)

install(TARGETS open_space_trajectory_post_process
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
