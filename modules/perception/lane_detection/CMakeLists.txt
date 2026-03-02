add_library(lane_detection_component SHARED)
target_sources(lane_detection_component
PRIVATE
	lane_detection_component.cc
	app/debug_info.cc
	app/lane_camera_perception.cc
	common/common_functions.cc
	lib/detector/darkSCNN/darkSCNN_lane_detector.cc
	lib/detector/denseline/denseline_lane_detector.cc
	lib/postprocessor/darkSCNN/darkSCNN_lane_postprocessor.cc
	lib/postprocessor/denseline/denseline_lane_postprocessor.cc
	proto/darkSCNN.pb.cc
	proto/darkSCNN_postprocessor.pb.cc
	proto/denseline.pb.cc
	proto/denseline_postprocessor.pb.cc
	proto/lane_perception_component.pb.cc
	proto/perception.pb.cc
)
# target_compile_definitions(lane_detection_component
# PUBLIC
#     MODULE_NAME="perception"
# )
target_link_libraries(lane_detection_component
PUBLIC
	cyber
	msg_proto
	modules_common
	perception_common
	Eigen3::Eigen
)
install(TARGETS lane_detection_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
