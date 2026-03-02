add_library(radar_detection_component SHARED)
target_sources(radar_detection_component
PRIVATE
	app/radar_obstacle_perception.cc
	common/radar_util.cc
	interface/base_matcher.cc
	lib/detector/conti_ars_detector/conti_ars_detector.cc
	lib/dummy/dummy_algorithms.cc
	lib/preprocessor/conti_ars_preprocessor/conti_ars_preprocessor.cc
	lib/roi_filter/hdmap_radar_roi_filter/hdmap_radar_roi_filter.cc
	lib/tracker/common/radar_track.cc
	lib/tracker/common/radar_track_manager.cc
	lib/tracker/conti_ars_tracker/conti_ars_tracker.cc
	lib/tracker/filter/adaptive_kalman_filter.cc
	lib/tracker/matcher/hm_matcher.cc
	radar_detection_component.cc
	proto/matcher_config.pb.cc
	proto/tracker_config.pb.cc
	proto/preprocessor.pb.cc
	proto/radar_component_config.pb.cc
	proto/radar_obstacle_perception.pb.cc
)
target_include_directories(radar_detection_component
PUBLIC
	${CUDA_INCLUDE_DIRS}
)
# target_compile_definitions(radar_detection_component
# PUBLIC
#     MODULE_NAME="radar_detection"
# )
target_link_libraries(radar_detection_component
PUBLIC
	cyber
	msg_proto
	modules_common
	perception_common
	Eigen3::Eigen
)
install(TARGETS radar_detection_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
