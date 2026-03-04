add_library(open_space_trajectory_optimizer_park SHARED
    open_space_trajectory_optimizer_park.cc
    optimizer.cc
    proto/open_space_trajectory_optimizer_park.pb.cc
)

target_link_libraries(open_space_trajectory_optimizer_park PUBLIC
    cyber
    planning_base
)

target_compile_options(open_space_trajectory_optimizer_park PRIVATE -fopenmp)
target_link_options(open_space_trajectory_optimizer_park PRIVATE -fopenmp)

install(TARGETS open_space_trajectory_optimizer_park
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
