add_library(open_space_roi_decider SHARED
    open_space_roi_decider.cc
    proto/open_space_roi_decider.pb.cc
)

target_link_libraries(open_space_roi_decider PUBLIC
    cyber
    planning_base
)

install(TARGETS open_space_roi_decider
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
