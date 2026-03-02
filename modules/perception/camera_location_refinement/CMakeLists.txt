add_library(camera_location_refinement_component SHARED)
target_sources(camera_location_refinement_component
PRIVATE
	camera_location_refinement_component.cc
	location_refiner/location_refiner_postprocessor.cc
	location_refiner/obj_postprocessor.cc
	location_refiner/proto/location_refiner.pb.cc
	proto/camera_location_refinement.pb.cc
)
target_include_directories(camera_location_refinement_component
PUBLIC
	${CUDA_INCLUDE_DIRS}
)
# target_compile_definitions(camera_location_refinement_component
# PUBLIC
#     MODULE_NAME="camera_location_refinement"
# )
target_link_libraries(camera_location_refinement_component
PUBLIC
	cyber
	msg_proto
	modules_common
)
install(TARGETS camera_location_refinement_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
