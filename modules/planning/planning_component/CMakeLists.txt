add_library(planning_component SHARED
    planning_component.cc
    navi_planning.cc
    on_lane_planning.cc
    planning_base.cc
)

target_link_libraries(planning_component PUBLIC
    cyber
    planning_base
)


install(TARGETS planning_component
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)