add_library(reuse_path SHARED
    reuse_path.cc
    proto/reuse_path.pb.cc
)

target_link_libraries(reuse_path PUBLIC
    cyber
    planning_base
)

install(TARGETS reuse_path
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
