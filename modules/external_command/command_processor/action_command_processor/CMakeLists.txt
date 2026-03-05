# ============================================================================
# Action Command Processor Plugin
# ============================================================================

add_library(action_command_processor_plugin SHARED
    action_command_processor.cc
    action_command_processor.h
    proto/action_command_config.pb.cc
)

set_target_properties(action_command_processor_plugin PROPERTIES
    OUTPUT_NAME "action_command_processor"
    PREFIX "lib"
    SUFFIX ".so"
)

target_link_libraries(action_command_processor_plugin PUBLIC
    cyber
    motion_command_processor_base
)

target_compile_definitions(action_command_processor_plugin PRIVATE
    MODULE_NAME="external_command"
)

install(TARGETS action_command_processor_plugin
    LIBRARY DESTINATION lib/external_command/command_processor/action_command_processor
)

install(DIRECTORY conf/
    DESTINATION lib/external_command/command_processor/action_command_processor/conf
)

install(FILES plugins.xml cyberfile.xml
    DESTINATION lib/external_command/command_processor/action_command_processor
)
