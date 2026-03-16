add_library(traffic_light_region_proposal_component SHARED)
target_sources(traffic_light_region_proposal_component
PRIVATE
	traffic_light_region_proposal_component.cc
	preprocessor/multi_camera_projection.cc
	preprocessor/tl_preprocessor.cc
	proto/trafficlights_proposal_component.pb.cc
)
# target_compile_definitions(traffic_light_region_proposal_component
# PUBLIC
#     MODULE_NAME="trafficlight"
# )
target_link_libraries(traffic_light_region_proposal_component
PUBLIC
	cyber
	msg_proto
	modules_common
	perception_common
	static_transform_component
	Eigen3::Eigen
)
install(TARGETS traffic_light_region_proposal_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
install(DIRECTORY conf DESTINATION  /apollo/output/modules/perception/traffic_light_region_proposal)
install(DIRECTORY dag  DESTINATION  /apollo/output/modules/perception/traffic_light_region_proposal)
install(DIRECTORY proto DESTINATION /apollo/output/modules/perception/traffic_light_region_proposal)
