# ============================================================================
# modules/perception/perception_plugin/CMakeLists.txt
# Plugins: dynamically loaded algorithm plugins
# ============================================================================

# ── lidar_detection/gpu_down_sample plugin (GPU only) ──
if(APOLLO_USE_GPU AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection/gpu_down_sample")
    add_library(gpu_down_sample SHARED)
    target_sources(gpu_down_sample
    PRIVATE
        lidar_detection/gpu_down_sample/gpu_down_sample.cc
        lidar_detection/gpu_down_sample/proto/gpu_down_sample.pb.cc
        lidar_detection/gpu_down_sample/voxel_downsample.cu
    )
    target_link_libraries(gpu_down_sample
    PUBLIC
        cyber
        perception_common
        Eigen3::Eigen
        ${CUDA_LIBRARIES}
        pcl
    )
    install(TARGETS gpu_down_sample
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin
    )
    set_target_properties(gpu_down_sample PROPERTIES
        CUDA_ARCHITECTURES "80;86"
    )
endif()

# ── inference/onnx_multi_batch plugin (GPU only) ──
if(APOLLO_USE_GPU AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/inference/onnx_multi_batch")
    add_library(onnx_multi_batch SHARED)
    target_sources(onnx_multi_batch
    PRIVATE
        inference/onnx_multi_batch/onnx_multi_batch_infer.cc
    )
    target_link_libraries(onnx_multi_batch
    PUBLIC
        cyber
        perception_common
        Eigen3::Eigen
        ${CUDA_LIBRARIES} ${CUDA_CUBLAS_LIBRARIES}
    )
    if(TARGET tensorrt)
        target_link_libraries(onnx_multi_batch PUBLIC tensorrt)
    endif()
    if(TARGET cudnn)
        target_link_libraries(onnx_multi_batch PUBLIC cudnn)
    endif()
    install(TARGETS onnx_multi_batch
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin
    )
endif()

# ── lidar_detection_filter/bigmot_refine_filter plugin ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection_filter/bigmot_refine_filter")
    add_library(bigmot_refine_filter SHARED)
    target_sources(bigmot_refine_filter
    PRIVATE
        lidar_detection_filter/bigmot_refine_filter/bigmot_refine_filter.cc
        lidar_detection_filter/bigmot_refine_filter/proto/bigmot_refine_filter.pb.cc
    )
    target_link_libraries(bigmot_refine_filter
    PUBLIC
        cyber
        perception_common
        Eigen3::Eigen
    )
    install(TARGETS bigmot_refine_filter
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin
    )
endif()

# ── lidar_detection_filter/mark_area_filter plugin ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection_filter/mark_area_filter")
    add_library(mark_area_filter SHARED)
    target_sources(mark_area_filter
    PRIVATE
        lidar_detection_filter/mark_area_filter/mark_area_filter.cc
        lidar_detection_filter/mark_area_filter/proto/mark_area_filter.pb.cc
    )
    target_link_libraries(mark_area_filter
    PUBLIC
        cyber
        perception_common
        Eigen3::Eigen
    )
    install(TARGETS mark_area_filter
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin
    )
endif()

# ── lidar_detection_filter/object_split_filter plugin ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection_filter/object_split_filter")
    add_library(object_split_filter SHARED)
    target_sources(object_split_filter
    PRIVATE
        lidar_detection_filter/object_split_filter/object_split_filter.cc
        lidar_detection_filter/object_split_filter/proto/object_split_filter.pb.cc
    )
    target_link_libraries(object_split_filter
    PUBLIC
        cyber
        perception_common
        Eigen3::Eigen
    )
    install(TARGETS object_split_filter
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin
    )
endif()

# ── lidar_detection_filter/semantic_filter plugin ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection_filter/semantic_filter")
    add_library(semantic_filter SHARED)
    target_sources(semantic_filter
    PRIVATE
        lidar_detection_filter/semantic_filter/semantic_filter.cc
        lidar_detection_filter/semantic_filter/proto/semantic_filter.pb.cc
    )
    target_link_libraries(semantic_filter
    PUBLIC
        cyber
        perception_common
        Eigen3::Eigen
    )
    install(TARGETS semantic_filter
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin
    )
endif()
