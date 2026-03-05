# ============================================================================
# Zone Cover Command Processor Plugin
# ============================================================================

add_library(zone_cover_command_processor_plugin SHARED
    zone_cover_command_processor.cc
    zone_cover_command_processor.h
)

set_target_properties(zone_cover_command_processor_plugin PROPERTIES
    OUTPUT_NAME "zone_cover_command_processor"
    PREFIX "lib"
    SUFFIX ".so"
)

target_link_libraries(zone_cover_command_processor_plugin PUBLIC
    cyber
    motion_command_processor_base
)

target_compile_definitions(zone_cover_command_processor_plugin PRIVATE
    MODULE_NAME="external_command"
)

install(TARGETS zone_cover_command_processor_plugin
    LIBRARY DESTINATION lib/external_command/command_processor/zone_cover_command_processor
)

install(DIRECTORY conf/
    DESTINATION lib/external_command/command_processor/zone_cover_command_processor/conf
)

install(FILES plugins.xml cyberfile.xml
    DESTINATION lib/external_command/command_processor/zone_cover_command_processor
)
