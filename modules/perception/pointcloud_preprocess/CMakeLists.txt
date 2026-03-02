add_library(pointcloud_preprocess_component SHARED)
target_sources(pointcloud_preprocess_component
PRIVATE
    preprocessor/pointcloud_preprocessor.cc
    preprocessor/proto/pointcloud_preprocessor_config.pb.cc
)
# target_compile_definitions(pointcloud_preprocess_component
# PUBLIC
#     MODULE_NAME="pointcloud_preprocess"
# )
target_link_libraries(pointcloud_preprocess_component
PUBLIC
    cyber
    msg_proto
    modules_common
    perception_common
)
target_include_directories(pointcloud_preprocess_component
PUBLIC
    ${CUDA_INCLUDE_DIRS}
)
install(TARGETS pointcloud_preprocess_component
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)