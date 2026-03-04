add_library(pull_over_path SHARED
    pull_over_path.cc
    proto/pull_over_path.pb.cc
)

target_link_libraries(pull_over_path PUBLIC
    cyber
    planning_base
)

install(TARGETS pull_over_path
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
