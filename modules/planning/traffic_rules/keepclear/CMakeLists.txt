add_library(keepclear SHARED
    keep_clear.cc
    proto/keepclear.pb.cc
)

target_link_libraries(keepclear PUBLIC
    cyber
    planning_base
)

install(TARGETS keepclear
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
