add_library(traffic_light_recognition_component SHARED)
target_sources(traffic_light_recognition_component
PRIVATE
	traffic_light_recognition_component.cc
	recognition/caffe_recognizer/classify.cc
	recognition/caffe_recognizer/recognition.cc
	recognition/efficient_net/efficient_net.cc
	proto/traffic_light_recognition_component.pb.cc
	recognition/caffe_recognizer/proto/model_param.pb.cc
	recognition/efficient_net/proto/efficient_net_param.pb.cc
)
# target_compile_definitions(traffic_light_recognition_component
# PUBLIC
#     MODULE_NAME="trafficlight"
# )
target_link_libraries(traffic_light_recognition_component
PUBLIC
	cyber
	msg_proto
	modules_common
	perception_common
	Eigen3::Eigen
)
install(TARGETS traffic_light_recognition_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
