add_library(msf_localization_component SHARED
    common/io/velodyne_utility.cc
    common/util/compression.cc
    common/util/file_utility.cc
    common/util/frame_transform.cc
    common/util/system_utility.cc
    local_map/base_map/base_map.cc
    local_map/base_map/base_map_config.cc
    local_map/base_map/base_map_matrix.cc
    local_map/base_map/base_map_node.cc
    local_map/base_map/base_map_node_index.cc
    local_map/base_map/base_map_pool.cc
    local_map/lossless_map/lossless_map.cc
    local_map/lossless_map/lossless_map_config.cc
    local_map/lossless_map/lossless_map_matrix.cc
    local_map/lossless_map/lossless_map_node.cc
    local_map/lossless_map/lossless_map_pool.cc
    local_map/lossy_map/lossy_map_2d.cc
    local_map/lossy_map/lossy_map_config_2d.cc
    local_map/lossy_map/lossy_map_matrix_2d.cc
    local_map/lossy_map/lossy_map_pool_2d.cc
    local_map/ndt_map/ndt_map.cc
    local_map/ndt_map/ndt_map_config.cc
    local_map/ndt_map/ndt_map_matrix.cc
    local_map/ndt_map/ndt_map_node.cc
    local_map/ndt_map/ndt_map_pool.cc
    local_pyramid_map/base_map/base_map.cc
    local_pyramid_map/base_map/base_map_config.cc
    local_pyramid_map/base_map/base_map_matrix.cc
    local_pyramid_map/base_map/base_map_node.cc
    local_pyramid_map/base_map/base_map_node_config.cc
    local_pyramid_map/base_map/base_map_node_index.cc
    local_pyramid_map/base_map/base_map_pool.cc
    local_pyramid_map/ndt_map/ndt_map.cc
    local_pyramid_map/ndt_map/ndt_map_config.cc
    local_pyramid_map/ndt_map/ndt_map_matrix.cc
    local_pyramid_map/ndt_map/ndt_map_matrix_handler.cc
    local_pyramid_map/ndt_map/ndt_map_node.cc
    local_pyramid_map/ndt_map/ndt_map_node_config.cc
    local_pyramid_map/ndt_map/ndt_map_pool.cc
    local_pyramid_map/pyramid_map/pyramid_map.cc
    local_pyramid_map/pyramid_map/pyramid_map_config.cc
    local_pyramid_map/pyramid_map/pyramid_map_matrix.cc
    local_pyramid_map/pyramid_map/pyramid_map_matrix_handler.cc
    local_pyramid_map/pyramid_map/pyramid_map_node.cc
    local_pyramid_map/pyramid_map/pyramid_map_node_config.cc
    local_pyramid_map/pyramid_map/pyramid_map_pool.cc
    local_tool/data_extraction/cyber_record_reader.cc
    local_tool/data_extraction/location_exporter.cc
    local_tool/data_extraction/pcd_exporter.cc
    local_tool/local_visualization/engine/visualization_engine.cc
    local_tool/local_visualization/engine/visualization_manager.cc
    local_tool/local_visualization/offline_visual/offline_local_visualizer.cc
    local_tool/map_creation/poses_interpolation/poses_interpolation.cc
    local_tool/map_creation/poses_interpolation/poses_interpolation.cc

    local_integ/localization_integ.cc
    local_integ/localization_integ_impl.cc
    local_integ/localization_gnss_process.cc
    local_integ/localization_lidar_process.cc
    local_integ/localization_integ_process.cc
    local_integ/measure_republish_process.cc
    local_integ/online_localization_expert.cc
    local_integ/gnss_msg_transfer.cc
    local_integ/lidar_msg_transfer.cc
    local_integ/localization_lidar.cc

    msf_localization.cc
    msf_localization_component.cc
)

target_link_libraries(msf_localization_component
PUBLIC
    cyber
    localization_common_object
    Eigen3::Eigen
    pcl
    yaml-cpp
    ${OpenCV_LIBS}
    localization_msf_lib
    localization_proto
)

target_include_directories(msf_localization_component
PUBLIC
    ${OpenCV_INCLUDE_DIRS}
)

install(TARGETS msf_localization_component
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)