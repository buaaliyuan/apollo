add_library(lidar_detection_component SHARED)
target_sources(lidar_detection_component
PRIVATE
	lidar_detection_component.cc
	detector/center_point_detection/center_point_detection.cc
	detector/cnn_segmentation/cnn_segmentation.cc
	detector/cnn_segmentation/feature_generator.cc
	detector/cnn_segmentation/feature_generator.cu
	detector/cnn_segmentation/spp_engine/spp_cluster_list.cc
	detector/cnn_segmentation/spp_engine/spp_engine.cc
	detector/cnn_segmentation/spp_engine/spp_label_image.cc
	detector/cnn_segmentation/spp_engine/spp_pool_types.cc
	detector/cnn_segmentation/spp_engine/spp_seg_cc_2d.cc
	detector/cnn_segmentation/spp_engine/spp_struct.cc
	detector/mask_pillars_detection/mask_pillars_detection.cc
	detector/point_pillars_detection/anchor_mask_cuda.cu
	detector/point_pillars_detection/nms_cuda.cu
	detector/point_pillars_detection/pfe_cuda.cu
	detector/point_pillars_detection/point_pillars.cc
	detector/point_pillars_detection/point_pillars_detection.cc
	detector/point_pillars_detection/postprocess_cuda.cu
	detector/point_pillars_detection/preprocess_points.cc
	detector/point_pillars_detection/preprocess_points_cuda.cu
	detector/point_pillars_detection/scatter_cuda.cu
	down_sample_bank/pcl_down_sample/pcl_down_sample.cc
	detector/center_point_detection/proto/model_param.pb.cc
	detector/cnn_segmentation/proto/model_param.pb.cc
	detector/mask_pillars_detection/proto/model_param.pb.cc
	detector/point_pillars_detection/proto/model_param.pb.cc
	down_sample_bank/pcl_down_sample/proto/pcl_down_sample.pb.cc
	proto/lidar_detection_component_config.pb.cc
)
target_include_directories(lidar_detection_component
PUBLIC
	${CUDA_INCLUDE_DIRS}
	${TORCH_INCLUDE_DIRS}
)
# target_compile_definitions(lidar_detection_component
# PUBLIC
#     MODULE_NAME="lidar_detection"
# )
target_link_libraries(lidar_detection_component
PUBLIC
	cyber
	msg_proto
	modules_common
    paddle_inference
    pcl
)
install(TARGETS lidar_detection_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
