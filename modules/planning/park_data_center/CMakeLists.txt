add_library(apollo_park_data_center SHARED
    park_data_center.cc
    nudge_info.cc
    util/lane_escape_util.cc
)

target_link_libraries(apollo_park_data_center PUBLIC
    cyber
    planning_base
)

install(TARGETS apollo_park_data_center
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)