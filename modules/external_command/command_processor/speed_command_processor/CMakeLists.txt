# ============================================================================
# Speed Command Processor Plugin
# ============================================================================

add_library(speed_command_processor_plugin SHARED
    speed_command_processor.cc
    speed_command_processor.h
)

set_target_properties(speed_command_processor_plugin PROPERTIES
    OUTPUT_NAME "speed_command_processor"
    PREFIX "lib"
    SUFFIX ".so"
)

target_link_libraries(speed_command_processor_plugin PUBLIC
    cyber
    motion_command_processor_base
)

target_compile_definitions(speed_command_processor_plugin PRIVATE
    MODULE_NAME="external_command"
)

install(TARGETS speed_command_processor_plugin
    LIBRARY DESTINATION lib/external_command/command_processor/speed_command_processor
)

install(DIRECTORY conf/
    DESTINATION lib/external_command/command_processor/speed_command_processor/conf
)

install(FILES plugins.xml cyberfile.xml
    DESTINATION lib/external_command/command_processor/speed_command_processor
)
