# ============================================================================
# Path Follow Command Processor Plugin
# ============================================================================

add_library(path_follow_command_processor_plugin SHARED
    path_follow_command_processor.cc
    path_follow_command_processor.h
)

set_target_properties(path_follow_command_processor_plugin PROPERTIES
    OUTPUT_NAME "path_follow_command_processor"
    PREFIX "lib"
    SUFFIX ".so"
)

target_link_libraries(path_follow_command_processor_plugin PUBLIC
    cyber
    motion_command_processor_base
)

target_compile_definitions(path_follow_command_processor_plugin PRIVATE
    MODULE_NAME="external_command"
)

install(TARGETS path_follow_command_processor_plugin
    LIBRARY DESTINATION lib/external_command/command_processor/path_follow_command_processor
)

install(DIRECTORY conf/
    DESTINATION lib/external_command/command_processor/path_follow_command_processor/conf
)

install(FILES plugins.xml cyberfile.xml
    DESTINATION lib/external_command/command_processor/path_follow_command_processor
)
