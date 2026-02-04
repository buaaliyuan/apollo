set(PREDICTION_PLUGIN_COMMON_LIBS
	cyberrt
	common_msg
	common
	gflags
	apollo_prediction
    tensorrt::tensorrt
)


# semantic_lstm_vehicle_tensorrt plugin
add_library(semantic_lstm_vehicle_tensorrt SHARED
    semantic_lstm_vehicle_tensorrt/semantic_lstm_vehicle_tensorrt.cc
    semantic_lstm_vehicle_tensorrt/semantic_lstm_vehicle_tensorrt.h
)
target_compile_definitions(semantic_lstm_vehicle_tensorrt PRIVATE MODULE_NAME=\"prediction\")
target_link_libraries(semantic_lstm_vehicle_tensorrt PUBLIC 
    ${PREDICTION_PLUGIN_COMMON_LIBS}
    CUDA::cudart
)
set_target_properties(semantic_lstm_vehicle_tensorrt PROPERTIES 
    POSITION_INDEPENDENT_CODE ON
)

# semantic_lstm_pedestrian_tensorrt plugin
add_library(semantic_lstm_pedestrian_tensorrt SHARED
    semantic_lstm_pedestrian_tensorrt/semantic_lstm_pedestrian_tensorrt.cc
    semantic_lstm_pedestrian_tensorrt/semantic_lstm_pedestrian_tensorrt.h
)
target_compile_definitions(semantic_lstm_pedestrian_tensorrt PRIVATE MODULE_NAME=\"prediction\")
target_link_libraries(semantic_lstm_pedestrian_tensorrt PUBLIC 
    ${PREDICTION_PLUGIN_COMMON_LIBS}
    CUDA::cudart
)
set_target_properties(semantic_lstm_pedestrian_tensorrt PROPERTIES 
    POSITION_INDEPENDENT_CODE ON
)

# multi_agent_vehicle_tensorrt plugin
add_library(multi_agent_vehicle_tensorrt SHARED
    multi_agent_vehicle_tensorrt/multi_agent_vehicle_tensorrt.cc
    multi_agent_vehicle_tensorrt/multi_agent_vehicle_tensorrt.h
)
target_compile_definitions(multi_agent_vehicle_tensorrt PRIVATE MODULE_NAME=\"prediction\")
target_link_libraries(multi_agent_vehicle_tensorrt PUBLIC 
    ${PREDICTION_PLUGIN_COMMON_LIBS}
    CUDA::cudart
)
set_target_properties(multi_agent_vehicle_tensorrt PROPERTIES 
    POSITION_INDEPENDENT_CODE ON
)

# multi_agent_pedestrian_tensorrt plugin
add_library(multi_agent_pedestrian_tensorrt SHARED
    multi_agent_pedestrian_tensorrt/multi_agent_pedestrian_tensorrt.cc
    multi_agent_pedestrian_tensorrt/multi_agent_pedestrian_tensorrt.h
)
target_compile_definitions(multi_agent_pedestrian_tensorrt PRIVATE MODULE_NAME=\"prediction\")
target_link_libraries(multi_agent_pedestrian_tensorrt PUBLIC 
    ${PREDICTION_PLUGIN_COMMON_LIBS}
    CUDA::cudart
)
set_target_properties(multi_agent_pedestrian_tensorrt PROPERTIES 
    POSITION_INDEPENDENT_CODE ON
)
