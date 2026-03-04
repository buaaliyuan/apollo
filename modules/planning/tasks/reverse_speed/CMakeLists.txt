add_library(reverse_speed SHARED
    reverse_speed.cc
    proto/reverse_speed.pb.cc
)

target_link_libraries(reverse_speed PUBLIC
    cyber
    planning_base
)

install(TARGETS reverse_speed
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
