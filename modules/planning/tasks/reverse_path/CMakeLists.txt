add_library(reverse_path SHARED
    reverse_path.cc
    proto/reverse_path.pb.cc
)

target_link_libraries(reverse_path PUBLIC
    cyber
    planning_base
)

install(TARGETS reverse_path
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
