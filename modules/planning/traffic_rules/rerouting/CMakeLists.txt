add_library(rerouting SHARED
    rerouting.cc
    proto/rerouting.pb.cc
)

target_link_libraries(rerouting PUBLIC
    cyber
    planning_base
)

install(TARGETS rerouting
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
