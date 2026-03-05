# ============================================================================
# Chassis Command Processor Plugin
# ============================================================================

add_library(chassis_command_processor_plugin SHARED
    chassis_command_processor.cc
    chassis_command_processor.h
)

set_target_properties(chassis_command_processor_plugin PROPERTIES
    OUTPUT_NAME "chassis_command_processor"
    PREFIX "lib"
    SUFFIX ".so"
)

target_link_libraries(chassis_command_processor_plugin PUBLIC
    cyber
    command_processor_base
)

target_compile_definitions(chassis_command_processor_plugin PRIVATE
    MODULE_NAME="external_command"
)

install(TARGETS chassis_command_processor_plugin
    LIBRARY DESTINATION lib/external_command/command_processor/chassis_command_processor
)

install(DIRECTORY conf/
    DESTINATION lib/external_command/command_processor/chassis_command_processor/conf
)

install(FILES plugins.xml cyberfile.xml
    DESTINATION lib/external_command/command_processor/chassis_command_processor
)
