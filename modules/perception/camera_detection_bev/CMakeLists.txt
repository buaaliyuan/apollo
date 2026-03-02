add_library(camera_detection_bev_component SHARED)
target_sources(camera_detection_bev_component
PRIVATE
	camera_detection_bev_component.cc
	detector/petr/bev_obstacle_detector.cc
	detector/petr/postprocess.cc
	detector/petr/preprocess.cc
	interface/base_obstacle_detector.cc
	detector/petr/proto/model_param.pb.cc
	proto/camera_detection_bev.pb.cc
)
target_include_directories(camera_detection_bev_component
PUBLIC
	${CUDA_INCLUDE_DIRS}
	${TORCH_INCLUDE_DIRS}
    ${OpenCV_INCLUDE_DIRS}
)
# target_compile_definitions(camera_detection_bev_component
# PUBLIC
#     MODULE_NAME="camera_detection_bev"
# )
target_link_libraries(camera_detection_bev_component
PUBLIC
	cyber
	msg_proto
	modules_common
    ${OpenCV_LIBS}
    tf2
)
install(TARGETS camera_detection_bev_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
