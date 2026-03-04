add_library(lane_borrow_path_generic SHARED
    lane_borrow_path_generic.cc
    proto/lane_borrow_path_generic.pb.cc
)

target_link_libraries(lane_borrow_path_generic PUBLIC
    cyber
    planning_base
)

install(TARGETS lane_borrow_path_generic
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
