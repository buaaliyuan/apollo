add_library(fallback_path SHARED
    fallback_path.cc
    proto/fallback_path.pb.cc
)

target_link_libraries(fallback_path PUBLIC
    cyber
    planning_base
)

install(TARGETS fallback_path
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
