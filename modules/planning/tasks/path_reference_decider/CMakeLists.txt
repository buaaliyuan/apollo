add_library(path_reference_decider SHARED
    path_reference_decider.cc
    proto/path_reference_decider.pb.cc
)

target_link_libraries(path_reference_decider PUBLIC
    cyber
    planning_base
)

install(TARGETS path_reference_decider
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
