add_library(lidar_tracking_component SHARED)
target_sources(lidar_tracking_component
PRIVATE
	lidar_tracking_component.cc
	classifier/fused_classifier/ccrf_type_fusion.cc
	classifier/fused_classifier/fused_classifier.cc
	classifier/fused_classifier/util.cc
	tracker/association/distance_collection.cc
	tracker/association/gnn_bipartite_graph_matcher.cc
	tracker/association/multi_hm_bipartite_graph_matcher.cc
	tracker/common/mlf_track_data.cc
	tracker/common/track_data.cc
	tracker/common/track_pool_types.cc
	tracker/common/tracked_object.cc
	tracker/measurement/measurement_collection.cc
	tracker/multi_lidar_fusion/mlf_engine.cc
	tracker/multi_lidar_fusion/mlf_motion_filter.cc
	tracker/multi_lidar_fusion/mlf_motion_measurement.cc
	tracker/multi_lidar_fusion/mlf_motion_refiner.cc
	tracker/multi_lidar_fusion/mlf_shape_filter.cc
	tracker/multi_lidar_fusion/mlf_track_object_distance.cc
	tracker/multi_lidar_fusion/mlf_track_object_matcher.cc
	tracker/multi_lidar_fusion/mlf_tracker.cc
	tracker/multi_lidar_fusion/mlf_type_filter.cc
	tracker/multi_lidar_fusion/mlf_direction_filter.cc
	tracker/multi_lidar_fusion/util.cc
	tracker/type_fusion/ccrf_type_fusion.cc
	tracker/type_fusion/util.cc
	proto/lidar_tracking_component_config.pb.cc
	classifier/fused_classifier/proto/ccrf_type_fusion_config.pb.cc
	classifier/fused_classifier/proto/fused_classifier_config.pb.cc
	tracker/type_fusion/proto/ccrf_type_filter_config.pb.cc
	tracker/multi_lidar_fusion/proto/multi_lidar_fusion_config.pb.cc
)
target_include_directories(lidar_tracking_component
PUBLIC
	${CUDA_INCLUDE_DIRS}
)
# target_compile_definitions(lidar_tracking_component
# PUBLIC
#     MODULE_NAME="lidar_tracking"
# )
target_link_libraries(lidar_tracking_component
PUBLIC
	cyber
	msg_proto
	modules_common
	perception_common
	Eigen3::Eigen
	leveldb
)
install(TARGETS lidar_tracking_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
