add_library(lane_follow_path SHARED
    lane_follow_path.cc
    proto/lane_follow_path.pb.cc
)

target_link_libraries(lane_follow_path PUBLIC
    cyber
    planning_base
)

install(TARGETS lane_follow_path
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
