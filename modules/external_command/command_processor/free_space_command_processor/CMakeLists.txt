# ============================================================================
# Free Space Command Processor Plugin
# ============================================================================

add_library(free_space_command_processor_plugin SHARED
    free_space_command_processor.cc
    free_space_command_processor.h
)

set_target_properties(free_space_command_processor_plugin PROPERTIES
    OUTPUT_NAME "free_space_command_processor"
    PREFIX "lib"
    SUFFIX ".so"
)

target_link_libraries(free_space_command_processor_plugin PUBLIC
    cyber
    motion_command_processor_base
)

target_compile_definitions(free_space_command_processor_plugin PRIVATE
    MODULE_NAME="external_command"
)

install(TARGETS free_space_command_processor_plugin
    LIBRARY DESTINATION lib/external_command/command_processor/free_space_command_processor
)

install(DIRECTORY conf/
    DESTINATION lib/external_command/command_processor/free_space_command_processor/conf
)

install(FILES plugins.xml cyberfile.xml
    DESTINATION lib/external_command/command_processor/free_space_command_processor
)
