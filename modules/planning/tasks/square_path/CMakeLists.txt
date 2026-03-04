add_library(square_path SHARED
    square_path.cc
    proto/square_path.pb.cc
)

target_link_libraries(square_path PUBLIC
    cyber
    planning_base
)

install(TARGETS square_path
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
