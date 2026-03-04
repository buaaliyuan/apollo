add_library(open_space_roi_decider_park SHARED
    open_space_roi_decider_park.cc
    proto/open_space_roi_decider_park.pb.cc
)

target_link_libraries(open_space_roi_decider_park PUBLIC
    cyber
    planning_base
)

install(TARGETS open_space_roi_decider_park
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
