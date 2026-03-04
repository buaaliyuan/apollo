add_library(path_decider SHARED
    path_decider.cc
    proto/path_decider.pb.cc
)

target_link_libraries(path_decider PUBLIC
    cyber
    planning_base
)

install(TARGETS path_decider
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
