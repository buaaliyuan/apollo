add_library(pointcloud_motion_component SHARED)
target_sources(pointcloud_motion_component
PRIVATE
    pointcloud_motion_component.cc
    parser/pointwise_unet/pointwise_unet.cc
    parser/pointwise_unet/pointwise_unet.cu
    parser/pointwise_unet/proto/motion_unet.pb.cc
    proto/pointcloud_motion_component_config.pb.cc
)

target_include_directories(pointcloud_motion_component
PUBLIC
    ${CUDA_INCLUDE_DIRS}
    ${TORCH_INCLUDE_DIRS}
)
# target_compile_definitions(pointcloud_motion_component
# PUBLIC
#     MODULE_NAME="pointcloud_motion"
# )
target_link_libraries(pointcloud_motion_component
PUBLIC
    cyber
    msg_proto
    modules_common
)
install(TARGETS pointcloud_motion_component
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)
set_target_properties(pointcloud_motion_component PROPERTIES
    CUDA_ARCHITECTURES "80;86" 
)