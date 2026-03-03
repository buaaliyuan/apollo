add_library(ndt_localization_component SHARED
    localization_pose_buffer.cc
    ndt_localization.cc
    ndt_localization_component.cc
    ndt_locator/lidar_locator_ndt.cc
)

target_link_libraries(ndt_localization_component PUBLIC
    cyber
    localization_common_object
    Eigen3::Eigen
    pcl
    ${OpenCV_LIBS}
    tf2
    yaml-cpp
)

install(TARGETS ndt_localization_component
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)