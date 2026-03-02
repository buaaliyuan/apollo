add_library(camera_detection_multi_stage_component SHARED)
target_sources(camera_detection_multi_stage_component
PRIVATE
	camera_detection_multi_stage_component.cc
	detector/yolo/object_maintainer.cc
	detector/yolo/postprocess.cc
	detector/yolo/postprocess.cu
	detector/yolo/yolo_obstacle_detector.cc
	detector/yolox3d/postprocess.cc
	detector/yolox3d/yolox3d_obstacle_detector.cc
	detector/yolo/proto/model_param.pb.cc
	detector/yolox3d/proto/model_param.pb.cc
	proto/camera_detection_multi_stage.pb.cc
)
target_include_directories(camera_detection_multi_stage_component
PUBLIC
	${CUDA_INCLUDE_DIRS}
	${TORCH_INCLUDE_DIRS}
    ${OpenCV_INCLUDE_DIRS}
)
# target_compile_definitions(camera_detection_multi_stage_component
# PUBLIC
#     MODULE_NAME="camera_detection_multi_stage"
# )
target_link_libraries(camera_detection_multi_stage_component
PUBLIC
	cyber
	msg_proto
	modules_common
    ${OpenCV_LIBS}
    tf2
)
install(TARGETS camera_detection_multi_stage_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
