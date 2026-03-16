add_library(traffic_light_detection_component SHARED)
target_sources(traffic_light_detection_component
PRIVATE
	traffic_light_detection_component.cc
	algorithm/cropbox.cc
	algorithm/select.cc
	detector/caffe_detection/detection.cc
	detector/yolox_detection/traffic_light_detection_yolox.cc
	proto/traffic_light_detection_component.pb.cc
	detector/caffe_detection/proto/model_param.pb.cc
	detector/yolox_detection/proto/model_param.pb.cc
)
# target_compile_definitions(traffic_light_detection_component
# PUBLIC
#     MODULE_NAME="trafficlight"
# )
target_link_libraries(traffic_light_detection_component
PUBLIC
	cyber
	msg_proto
	modules_common
	perception_common
	Eigen3::Eigen
)
install(TARGETS traffic_light_detection_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
install(DIRECTORY conf DESTINATION /apollo/output/modules/perception/traffic_light_detection)
install(DIRECTORY dag  DESTINATION /apollo/output/modules/perception/traffic_light_detection)
install(DIRECTORY data DESTINATION /apollo/output/modules/perception/traffic_light_detection)
install(DIRECTORY proto DESTINATION /apollo/output/modules/perception/traffic_light_detection)
