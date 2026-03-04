add_library(stop_sign SHARED
    stop_sign.cc
    proto/stop_sign.pb.cc
)

target_link_libraries(stop_sign PUBLIC
    cyber
    planning_base
)

install(TARGETS stop_sign
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
