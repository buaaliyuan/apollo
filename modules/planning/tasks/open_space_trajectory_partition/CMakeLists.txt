add_library(open_space_trajectory_partition SHARED
    open_space_trajectory_partition.cc
    proto/open_space_trajectory_partition.pb.cc
)

target_link_libraries(open_space_trajectory_partition PUBLIC
    cyber
    planning_base
)

install(TARGETS open_space_trajectory_partition
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
