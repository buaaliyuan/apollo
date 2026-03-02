add_library(camera_detection_single_stage_component SHARED)
target_sources(camera_detection_single_stage_component
PRIVATE
	camera_detection_single_stage_component.cc
	detector/caddn/caddn_obstacle_detector.cc
	detector/caddn/postprocess.cc
	detector/smoke/postprocess.cc
	detector/smoke/smoke_obstacle_detector.cc
	detector/caddn/proto/model_param.pb.cc
	detector/smoke/proto/model_param.pb.cc
	proto/camera_detection_single_stage.pb.cc
)
target_include_directories(camera_detection_single_stage_component
PUBLIC
	${CUDA_INCLUDE_DIRS}
	${TORCH_INCLUDE_DIRS}
    ${OpenCV_INCLUDE_DIRS}
)
# target_compile_definitions(camera_detection_single_stage_component
# PUBLIC
#     MODULE_NAME="camera_detection_single_stage"
# )
target_link_libraries(camera_detection_single_stage_component
PUBLIC
	cyber
	msg_proto
	modules_common
    ${OpenCV_LIBS}
    tf2
)
install(TARGETS camera_detection_single_stage_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
