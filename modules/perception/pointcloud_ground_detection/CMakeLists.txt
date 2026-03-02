add_library(pointcloud_ground_detection_component SHARED)
target_sources(pointcloud_ground_detection_component
PRIVATE
    pointcloud_ground_detection_component.cc
    ground_detector/ground_service_detector/ground_service_detector.cc
    ground_detector/spatio_temporal_ground_detector/spatio_temporal_ground_detector.cc
    ground_detector/proto/ground_service_detector_config.pb.cc
    ground_detector/proto/spatio_temporal_ground_detector_config.pb.cc
    proto/pointcloud_ground_detection_component_config.pb.cc
)
target_include_directories(pointcloud_ground_detection_component
PUBLIC
    ${CUDA_INCLUDE_DIRS}
)
# target_compile_definitions(pointcloud_ground_detection_component
# PUBLIC
#     MODULE_NAME="pointcloud_ground_detection"
# )
target_link_libraries(pointcloud_ground_detection_component
PUBLIC
    cyber
    msg_proto
    modules_common
)
install(TARGETS pointcloud_ground_detection_component
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)
