# ============================================================================
# Command Processor Module
# ============================================================================

# Base library (must be built first as other processors depend on it)
add_subdirectory(command_processor_base)

# Command processor plugins
add_subdirectory(action_command_processor)
add_subdirectory(chassis_command_processor)
add_subdirectory(free_space_command_processor)
add_subdirectory(lane_follow_command_processor)
add_subdirectory(path_follow_command_processor)
add_subdirectory(precise_parking_command_processor)
add_subdirectory(speed_command_processor)
add_subdirectory(valet_parking_command_processor)
add_subdirectory(zone_cover_command_processor)
