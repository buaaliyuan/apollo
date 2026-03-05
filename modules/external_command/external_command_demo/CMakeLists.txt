# ============================================================================
# External Command Demo
# ============================================================================

add_library(external_command_demo SHARED
    external_command_demo.cc
    external_command_demo.h
    proto/demo_config.pb.cc
    proto/sweeper_custom_command.pb.cc
)

set_target_properties(external_command_demo PROPERTIES
    OUTPUT_NAME "external_command_demo"
    PREFIX "lib"
    SUFFIX ".so"
)

target_link_libraries(external_command_demo PUBLIC
    cyber
)

target_compile_definitions(external_command_demo PRIVATE
    MODULE_NAME="external_command"
)

add_library(external_command_wrapper_demo SHARED
    external_command_wrapper_demo.cc
    external_command_wrapper_demo.h
)

set_target_properties(external_command_wrapper_demo PROPERTIES
    OUTPUT_NAME "external_command_wrapper_demo"
    PREFIX "lib"
    SUFFIX ".so"
)

target_link_libraries(external_command_wrapper_demo PUBLIC
    cyber
    Eigen3::Eigen
)

target_compile_definitions(external_command_wrapper_demo PRIVATE
    MODULE_NAME="external_command"
)

install(TARGETS external_command_demo external_command_wrapper_demo
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(DIRECTORY conf/
    DESTINATION share/external_command/external_command_demo/conf
)

install(DIRECTORY dag/
    DESTINATION share/external_command/external_command_demo/dag
)

install(DIRECTORY launch/
    DESTINATION share/external_command/external_command_demo/launch
)

install(FILES cyberfile.xml
    DESTINATION share/external_command/external_command_demo
)
