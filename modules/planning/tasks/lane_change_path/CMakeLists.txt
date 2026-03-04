add_library(lane_change_path SHARED
    lane_change_path.cc
    proto/lane_change_path.pb.cc
)

target_link_libraries(lane_change_path PUBLIC
    cyber
    planning_base
)

install(TARGETS lane_change_path
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
