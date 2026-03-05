# ============================================================================
# Lane Follow Command Processor Plugin
# ============================================================================

add_library(lane_follow_command_processor_plugin SHARED
    lane_follow_command_processor.cc
    lane_follow_command_processor.h
)

set_target_properties(lane_follow_command_processor_plugin PROPERTIES
    OUTPUT_NAME "lane_follow_command_processor"
    PREFIX "lib"
    SUFFIX ".so"
)

target_link_libraries(lane_follow_command_processor_plugin PUBLIC
    cyber
    motion_command_processor_base
)

target_compile_definitions(lane_follow_command_processor_plugin PRIVATE
    MODULE_NAME="external_command"
)

install(TARGETS lane_follow_command_processor_plugin
    LIBRARY DESTINATION lib/external_command/command_processor/lane_follow_command_processor
)

install(DIRECTORY conf/
    DESTINATION lib/external_command/command_processor/lane_follow_command_processor/conf
)

install(FILES plugins.xml cyberfile.xml
    DESTINATION lib/external_command/command_processor/lane_follow_command_processor
)
