add_library(camera_location_estimation_component SHARED)
target_sources(camera_location_estimation_component
PRIVATE
	camera_location_estimation_component.cc
	transformer/multicue/multicue_transformer.cc
	transformer/multicue/obj_mapper.cc
	transformer/singlestage/singlestage_transformer.cc
	proto/camera_location_estimation.pb.cc
	transformer/multicue/proto/multicue.pb.cc
	transformer/singlestage/proto/singlestage.pb.cc
)
target_include_directories(camera_location_estimation_component
PUBLIC
	${CUDA_INCLUDE_DIRS}
)
# target_compile_definitions(camera_location_estimation_component
# PUBLIC
#     MODULE_NAME="camera_location_estimation"
# )
target_link_libraries(camera_location_estimation_component
PUBLIC
	cyber
	msg_proto
	modules_common
)
install(TARGETS camera_location_estimation_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
