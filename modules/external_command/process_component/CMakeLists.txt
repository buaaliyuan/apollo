# ============================================================================
# External Command Process Component
# ============================================================================

add_library(external_command_process_component SHARED
    external_command_process_component.cc
    external_command_process_component.h
    proto/process_component_config.pb.cc
)

set_target_properties(external_command_process_component PROPERTIES
    OUTPUT_NAME "external_command_process_component"
    PREFIX "lib"
    SUFFIX ".so"
)

target_link_libraries(external_command_process_component PUBLIC
    cyber
    command_processor_base
)

target_compile_definitions(external_command_process_component PRIVATE
    MODULE_NAME="external_command"
)

install(TARGETS external_command_process_component
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(DIRECTORY conf/
    DESTINATION share/external_command/process_component/conf
)

install(DIRECTORY dag/
    DESTINATION share/external_command/process_component/dag
)

install(DIRECTORY launch/
    DESTINATION share/external_command/process_component/launch
)

install(FILES cyberfile.xml
    DESTINATION share/external_command/process_component
)
