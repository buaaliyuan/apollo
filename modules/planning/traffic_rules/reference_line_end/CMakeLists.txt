add_library(reference_line_end SHARED
    reference_line_end.cc
    proto/reference_line_end.pb.cc
)

target_link_libraries(reference_line_end PUBLIC
    cyber
    planning_base
)

install(TARGETS reference_line_end
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
