# ============================================================================
# modules/common_msgs/CMakeLists.txt
# All proto message definitions used across Apollo modules
# ============================================================================

# Foundational (no inter-package deps)
add_subdirectory(basic_msgs)
add_subdirectory(drivers_msgs)

# Depend on basic_msgs
add_subdirectory(localization_msgs)
add_subdirectory(chassis_msgs)
add_subdirectory(config_msgs)
add_subdirectory(monitor_msgs)
add_subdirectory(map_msgs)
add_subdirectory(control_msgs)
add_subdirectory(storytelling_msgs)
add_subdirectory(transform_msgs)
add_subdirectory(v2x_msgs)

# Depend on map_msgs + basic_msgs
add_subdirectory(perception_msgs)
add_subdirectory(routing_msgs)

# Depend on basic_msgs + localization_msgs
add_subdirectory(audio_msgs)

# Depend on perception_msgs, map_msgs
add_subdirectory(prediction_msgs)

# Depend on routing_msgs, basic_msgs
add_subdirectory(external_command_msgs)

# Depend on control_msgs
add_subdirectory(guardian_msgs)

# Depend on many packages
add_subdirectory(sensor_msgs)
add_subdirectory(dreamview_msgs)
add_subdirectory(planning_msgs)
add_subdirectory(simulation_msgs)
add_subdirectory(task_manager_msgs)
