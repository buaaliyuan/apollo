add_library(traffic_light_tracking_component SHARED)
target_sources(traffic_light_tracking_component
PRIVATE
	traffic_light_tracking_component.cc
	tracker/semantic_decision.cc
	proto/traffic_light_tracking_component.pb.cc
	tracker/proto/semantic.pb.cc
)
# target_compile_definitions(traffic_light_tracking_component
# PUBLIC
#     MODULE_NAME="trafficlight"
# )
target_link_libraries(traffic_light_tracking_component
PUBLIC
	cyber
	msg_proto
	modules_common
	perception_common
	Eigen3::Eigen
)
install(TARGETS traffic_light_tracking_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
install(DIRECTORY conf DESTINATION /apollo/output/modules/perception/traffic_light_tracking)
install(DIRECTORY dag DESTINATION /apollo/output/modules/perception/traffic_light_tracking)
install(DIRECTORY data DESTINATION /apollo/output/modules/perception/traffic_light_tracking)
install(DIRECTORY proto DESTINATION /apollo/output/modules/perception/traffic_light_tracking)
