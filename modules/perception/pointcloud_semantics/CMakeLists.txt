add_library(pointcloud_semantic_component SHARED)
target_sources(pointcloud_semantic_component
PRIVATE
    pointcloud_semantic_component.cc
    parser/pointwise_unet/pointwise_unet.cc
    parser/pointwise_unet/pointwise_unet.cu
    parser/pointwise_unet/proto/pointwise_unet.pb.cc
    proto/pointcloud_semantic_component_config.pb.cc
)
target_include_directories(pointcloud_semantic_component
PUBLIC
    ${CUDA_INCLUDE_DIRS}
    ${TORCH_INCLUDE_DIRS}
)
# target_compile_definitions(pointcloud_semantic_component
# PUBLIC
#     MODULE_NAME="pointcloud_semantics"
# )
target_link_libraries(pointcloud_semantic_component
PUBLIC
    cyber
    msg_proto
    modules_common
    Eigen3::Eigen
)
install(TARGETS pointcloud_semantic_component
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)
