# ============================================================================
# Semantic LSTM Vehicle TensorRT Plugin
# ============================================================================

add_library(semantic_lstm_vehicle_tensorrt_plugin SHARED
    semantic_lstm_vehicle_tensorrt.cc
    semantic_lstm_vehicle_tensorrt.h
)

# Set output name to libmodel.so
set_target_properties(semantic_lstm_vehicle_tensorrt_plugin PROPERTIES
    OUTPUT_NAME "model"
    PREFIX "lib"
)

target_link_libraries(semantic_lstm_vehicle_tensorrt_plugin PUBLIC
    cyber
    prediction_component
    ${CUDA_LIBRARIES}
    ${TENSORRT_LIBRARIES}
)

target_include_directories(semantic_lstm_vehicle_tensorrt_plugin PUBLIC
    ${CUDA_INCLUDE_DIRS}
    ${TENSORRT_INCLUDE_DIRS}
)

# Install to separate directory to avoid conflicts
install(TARGETS semantic_lstm_vehicle_tensorrt_plugin
    LIBRARY DESTINATION lib/prediction_plugin/semantic_lstm_vehicle_tensorrt
    ARCHIVE DESTINATION lib/prediction_plugin/semantic_lstm_vehicle_tensorrt
)

# Install configuration and data files
install(DIRECTORY conf/
    DESTINATION lib/prediction_plugin/semantic_lstm_vehicle_tensorrt/conf
)

install(DIRECTORY data/
    DESTINATION lib/prediction_plugin/semantic_lstm_vehicle_tensorrt/data
)

# Install plugin descriptor
install(FILES plugins.xml cyberfile.xml
    DESTINATION lib/prediction_plugin/semantic_lstm_vehicle_tensorrt
)
