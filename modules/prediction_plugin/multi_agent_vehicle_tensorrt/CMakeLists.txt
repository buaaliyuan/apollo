# ============================================================================
# Multi-Agent Vehicle TensorRT Plugin
# ============================================================================

add_library(multi_agent_vehicle_tensorrt_plugin SHARED
    multi_agent_vehicle_tensorrt.cc
    multi_agent_vehicle_tensorrt.h
)

# Set output name to libmodel.so
set_target_properties(multi_agent_vehicle_tensorrt_plugin PROPERTIES
    OUTPUT_NAME "model"
    PREFIX "lib"
)

target_link_libraries(multi_agent_vehicle_tensorrt_plugin PUBLIC
    cyber
    prediction_component
    ${CUDA_LIBRARIES}
    ${TENSORRT_LIBRARIES}
)

target_include_directories(multi_agent_vehicle_tensorrt_plugin PUBLIC
    ${CUDA_INCLUDE_DIRS}
    ${TENSORRT_INCLUDE_DIRS}
)

# Install to separate directory to avoid conflicts
install(TARGETS multi_agent_vehicle_tensorrt_plugin
    LIBRARY DESTINATION lib/prediction_plugin/multi_agent_vehicle_tensorrt
    ARCHIVE DESTINATION lib/prediction_plugin/multi_agent_vehicle_tensorrt
)

# Install configuration and data files
install(DIRECTORY conf/
    DESTINATION lib/prediction_plugin/multi_agent_vehicle_tensorrt/conf
)

install(DIRECTORY data/
    DESTINATION lib/prediction_plugin/multi_agent_vehicle_tensorrt/data
)

# Install plugin descriptor
install(FILES plugins.xml cyberfile.xml
    DESTINATION lib/prediction_plugin/multi_agent_vehicle_tensorrt
)
