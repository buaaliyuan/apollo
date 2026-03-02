add_library(camera_tracking_component SHARED)
target_sources(camera_tracking_component
PRIVATE
	camera_tracking_component.cc
	base/obstacle_reference.cc
	base/target.cc
	common/kalman_filter.cc
	common/similar.cc
	common/similar.cu
	feature_extract/external_feature_extractor.cc
	feature_extract/project_feature.cc
	feature_extract/tracking_feat_extractor.cc
	tracking/omt_obstacle_tracker.cc
	feature_extract/proto/model_param.pb.cc
	proto/camera_tracking_component.pb.cc
	proto/omt.pb.cc
	proto/tracking_feature.pb.cc
)
target_include_directories(camera_tracking_component
PUBLIC
	${CUDA_INCLUDE_DIRS}
	${TORCH_INCLUDE_DIRS}
)
# target_compile_definitions(camera_tracking_component
# PUBLIC
#     MODULE_NAME="camera_tracking"
# )
target_link_libraries(camera_tracking_component
PUBLIC
	cyber
	msg_proto
	modules_common
)
install(TARGETS camera_tracking_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
