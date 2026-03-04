add_library(backside_vehicle SHARED
    backside_vehicle.cc
    proto/backside_vehicle.pb.cc
)

target_link_libraries(backside_vehicle PUBLIC
    cyber
    planning_base
)

install(TARGETS backside_vehicle
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
