add_library(large_curvature_scenario SHARED
    large_curvature_scenario.cc
    stage_large_curvature.cc
    proto/large_curvature_scenario.pb.cc
)

target_link_libraries(large_curvature_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS large_curvature_scenario
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
