add_library(pointcloud_map_based_roi_component SHARED)
target_sources(pointcloud_map_based_roi_component
PRIVATE
    map_manager/map_manager.cc
    map_manager/proto/map_manager_config.pb.cc
    proto/pointcloud_map_based_roi_component_config.pb.cc
    roi_filter/hdmap_roi_filter/hdmap_roi_filter.cc
    roi_filter/hdmap_roi_filter/proto/hdmap_roi_filter.pb.cc
    roi_filter/roi_service_filter/roi_service_filter.cc
)
target_include_directories(pointcloud_map_based_roi_component
PUBLIC
    ${CUDA_INCLUDE_DIRS}
)
# target_compile_definitions(pointcloud_map_based_roi_component
# PUBLIC
#     MODULE_NAME="pointcloud_map_based_roi"
# )
target_link_libraries(pointcloud_map_based_roi_component
PUBLIC
    cyber
    msg_proto
    modules_common
)
install(TARGETS pointcloud_map_based_roi_component
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)