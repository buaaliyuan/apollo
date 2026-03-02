add_library(radar4d_detection_component SHARED)
target_sources(radar4d_detection_component
PRIVATE
	app/radar_obstacle_perception.cc
	lib/classifier/ccrf_type_fusion.cc
	lib/classifier/fused_classifier.cc
	lib/classifier/util.cc
	lib/detector/point_pillars_detection/point_pillars.cc
	lib/detector/point_pillars_detection/point_pillars_detection.cc
	lib/detector/point_pillars_detection/preprocess_points.cc
	lib/object_builder/object_builder.cc
	lib/preprocessor/radar_preprocessor.cc
	lib/roi_filter/hdmap_radar_roi_filter.cc
	lib/tracker/association/distance_collection.cc
	lib/tracker/association/gnn_bipartite_graph_matcher.cc
	lib/tracker/association/multi_hm_bipartite_graph_matcher.cc
	lib/tracker/common/mrf_track_data.cc
	lib/tracker/common/track_data.cc
	lib/tracker/common/track_pool_types.cc
	lib/tracker/common/tracked_object.cc
	lib/tracker/measurement/measurement_collection.cc
	lib/tracker/multi_radar_fusion/mrf_engine.cc
	lib/tracker/multi_radar_fusion/mrf_motion_filter.cc
	lib/tracker/multi_radar_fusion/mrf_motion_measurement.cc
	lib/tracker/multi_radar_fusion/mrf_motion_refiner.cc
	lib/tracker/multi_radar_fusion/mrf_shape_filter.cc
	lib/tracker/multi_radar_fusion/mrf_track_object_distance.cc
	lib/tracker/multi_radar_fusion/mrf_track_object_matcher.cc
	lib/tracker/multi_radar_fusion/mrf_tracker.cc
	lib/tracker/semantic_map/evaluator_manager.cc
	radar4d_detection_component.cc
	proto/preprocessor_config.pb.cc
	proto/radar4d_component_config.pb.cc
	proto/radar_obstacle_perception_config.pb.cc
	lib/classifier/proto/ccrf_type_fusion_config.pb.cc
	lib/classifier/proto/fused_classifier_config.pb.cc
	lib/detector/point_pillars_detection/proto/model_param.pb.cc
	lib/tracker/multi_radar_fusion/proto/mrf_config.pb.cc
)
target_include_directories(radar4d_detection_component
PUBLIC
	${CUDA_INCLUDE_DIRS}
	${TORCH_INCLUDE_DIRS}
    ${PYTHON_INCLUDE_DIRS}
)
# target_compile_definitions(radar4d_detection_component
# PUBLIC
#     MODULE_NAME="radar4d_detection"
# )
target_link_libraries(radar4d_detection_component
PUBLIC
	cyber
	msg_proto
	modules_common
	perception_common
	paddle_inference
	pcl
	Eigen3::Eigen
	leveldb
)
install(TARGETS radar4d_detection_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
