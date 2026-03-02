add_library(lidar_cpdet_detection_component SHARED)
target_sources(lidar_cpdet_detection_component
PRIVATE
	lidar_cpdetection_component.cc
	detector/cpdet/cpdet.cc
	detector/cpdet/cpdet.cu
	down_sample_bank/pcl_method/pcl_method.cc
	proto/lidar_cpdet_detection_component_config.pb.cc
	detector/cpdet/proto/model_param.pb.cc
	down_sample_bank/pcl_method/proto/pcl_method.pb.cc
)
target_include_directories(lidar_cpdet_detection_component
PUBLIC
	${CUDA_INCLUDE_DIRS}
	${TORCH_INCLUDE_DIRS}
)
# target_compile_definitions(lidar_cpdet_detection_component
# PUBLIC
#     MODULE_NAME="lidar_cpdet_detection"
# )
target_link_libraries(lidar_cpdet_detection_component
PUBLIC
	cyber
	msg_proto
	modules_common
	perception_common
	paddle_inference
	pcl
	Eigen3::Eigen
	leveldb
)
install(TARGETS lidar_cpdet_detection_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)

