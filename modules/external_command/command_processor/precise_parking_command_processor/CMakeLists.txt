# ============================================================================
# Precise Parking Command Processor Plugin
# ============================================================================

add_library(precise_parking_command_processor_plugin SHARED
    precise_parking_command_processor.cc
    precise_parking_command_processor.h
)

set_target_properties(precise_parking_command_processor_plugin PROPERTIES
    OUTPUT_NAME "precise_parking_command_processor"
    PREFIX "lib"
    SUFFIX ".so"
)

target_link_libraries(precise_parking_command_processor_plugin PUBLIC
    cyber
    motion_command_processor_base
)

target_compile_definitions(precise_parking_command_processor_plugin PRIVATE
    MODULE_NAME="external_command"
)

install(TARGETS precise_parking_command_processor_plugin
    LIBRARY DESTINATION lib/external_command/command_processor/precise_parking_command_processor
)

install(DIRECTORY conf/
    DESTINATION lib/external_command/command_processor/precise_parking_command_processor/conf
)

install(FILES plugins.xml cyberfile.xml
    DESTINATION lib/external_command/command_processor/precise_parking_command_processor
)
