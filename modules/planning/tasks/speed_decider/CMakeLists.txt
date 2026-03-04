add_library(speed_decider SHARED
    speed_decider.cc
    proto/speed_decider.pb.cc
)

target_link_libraries(speed_decider PUBLIC
    cyber
    planning_base
)

install(TARGETS speed_decider
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
