add_library(traffic_light SHARED
    traffic_light.cc
    proto/traffic_light.pb.cc
)

target_link_libraries(traffic_light PUBLIC
    cyber
    planning_base
)

install(TARGETS traffic_light
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
