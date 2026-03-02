add_library(multi_sensor_fusion_component SHARED)
target_sources(multi_sensor_fusion_component
PRIVATE
	multi_sensor_fusion_component.cc
	base/scene.cc
	base/sensor.cc
	base/sensor_data_manager.cc
	base/sensor_frame.cc
	base/sensor_object.cc
	base/track.cc
	base/track_pool_types.cc
	common/camera_util.cc
	common/dst_evidence.cc
	common/information_filter.cc
	common/kalman_filter.cc
	fusion/data_association/hm_data_association/hm_tracks_objects_match.cc
	fusion/data_association/hm_data_association/probabilities.cc
	fusion/data_association/hm_data_association/track_object_distance.cc
	fusion/data_association/hm_data_association/track_object_similarity.cc
	fusion/data_fusion/existence_fusion/dst_existence_fusion/dst_existence_fusion.cc
	fusion/data_fusion/motion_fusion/kalman_motion_fusion/kalman_motion_fusion.cc
	fusion/data_fusion/shape_fusion/pbf_shape_fusion/pbf_shape_fusion.cc
	fusion/data_fusion/tracker/pbf_tracker/pbf_tracker.cc
	fusion/data_fusion/type_fusion/dst_type_fusion/dst_type_fusion.cc
	fusion/dummy/dummy_algorithms.cc
	fusion/fusion_system/probabilistic_fusion/probabilistic_fusion.cc
	fusion/gatekeeper/pbf_gatekeeper/pbf_gatekeeper.cc
	proto/dst_existence_fusion_config.pb.cc
	proto/pbf_tracker_config.pb.cc
	proto/pbf_gatekeeper_config.pb.cc
	proto/fusion_component_config.pb.cc
	proto/probabilistic_fusion_config.pb.cc
	proto/dst_type_fusion_config.pb.cc
)
# target_compile_definitions(multi_sensor_fusion_component
# PUBLIC
#     MODULE_NAME="multi_sensor_fusion"
# )
target_link_libraries(multi_sensor_fusion_component
PUBLIC
	cyber
	msg_proto
	modules_common
	perception_common
	Eigen3::Eigen
)
install(TARGETS multi_sensor_fusion_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
