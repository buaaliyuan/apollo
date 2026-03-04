add_library(lane_follow_map SHARED
    lane_follow_map.cc
)

target_link_libraries(lane_follow_map PUBLIC
    cyber
    planning_base
)

install(TARGETS lane_follow_map
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)