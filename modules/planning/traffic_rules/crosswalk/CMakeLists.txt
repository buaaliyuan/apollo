add_library(crosswalk SHARED
    crosswalk.cc
    proto/crosswalk.pb.cc
)

target_link_libraries(crosswalk PUBLIC
    cyber
    planning_base
)

install(TARGETS crosswalk
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
