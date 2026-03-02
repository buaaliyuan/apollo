add_library(lidar_segmentation_component SHARED)
target_sources(lidar_segmentation_component
PRIVATE
	lidar_segmentation_component.cc
	common/bg_object_builder.cc
	common/object_split.cc
	common/semantic_builder.cc
	segmentor/graph_segmentation/background_map.cc
	segmentor/graph_segmentation/graph_segmentation.cc
	segmentor/ncut_segmentation/common/flood_fill.cc
	segmentor/ncut_segmentation/ncut.cc
	segmentor/ncut_segmentation/ncut_segmentation.cc
	proto/lidar_segmentation_component_config.pb.cc
	segmentor/graph_segmentation/proto/graph_segmentation_config.pb.cc
	segmentor/ncut_segmentation/proto/ncut_config.pb.cc
	segmentor/ncut_segmentation/proto/ncut_param.pb.cc
)
target_include_directories(lidar_segmentation_component
PUBLIC
	${CUDA_INCLUDE_DIRS}
    ${OpenCV_INCLUDE_DIRS}
)
# target_compile_definitions(lidar_segmentation_component
# PUBLIC
#     MODULE_NAME="lidar_segmentation"
# )
target_link_libraries(lidar_segmentation_component
PUBLIC
	cyber
	msg_proto
	modules_common
    ${OpenCV_LIBS}
    pcl
)
install(TARGETS lidar_segmentation_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
