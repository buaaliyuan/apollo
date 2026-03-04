add_library(open_space_trajectory_provider SHARED
    open_space_trajectory_provider.cc
    open_space_trajectory_optimizer.cc
    proto/open_space_trajectory_provider.pb.cc
)

target_link_libraries(open_space_trajectory_provider PUBLIC
    cyber
    planning_base
)

install(TARGETS open_space_trajectory_provider
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

target_compile_options(open_space_trajectory_provider PRIVATE -fopenmp)