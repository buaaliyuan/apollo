add_library(bare_intersection_unprotected_scenario SHARED
    bare_intersection_unprotected_scenario.cc
    proto/bare_intersection_unprotected_scenario.pb.cc
)

target_link_libraries(bare_intersection_unprotected_scenario PUBLIC
    cyber
    planning_base
)

install(TARGETS bare_intersection_unprotected_scenario
    RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
    LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
    ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
)