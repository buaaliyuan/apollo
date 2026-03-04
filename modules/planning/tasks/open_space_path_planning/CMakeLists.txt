add_library(open_space_path_planning SHARED
    open_space_path_planning.cc
    proto/open_space_path_planning.pb.cc
)

target_link_libraries(open_space_path_planning PUBLIC
    cyber
    planning_base
)

install(TARGETS open_space_path_planning
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
