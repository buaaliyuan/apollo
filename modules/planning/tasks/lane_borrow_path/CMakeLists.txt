add_library(lane_borrow_path SHARED
    lane_borrow_path.cc
    proto/lane_borrow_path.pb.cc
)

target_link_libraries(lane_borrow_path PUBLIC
    cyber
    planning_base
)

install(TARGETS lane_borrow_path
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
