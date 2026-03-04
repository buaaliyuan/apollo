add_library(destination SHARED
    destination.cc
    proto/destination.pb.cc
)

target_link_libraries(destination PUBLIC
    cyber
    planning_base
)

install(TARGETS destination
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
