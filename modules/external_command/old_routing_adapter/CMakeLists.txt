# ============================================================================
# Old Routing Adapter Component
# ============================================================================

add_library(old_routing_adapter SHARED
    old_routing_adapter.cc
    old_routing_adapter.h
    proto/old_routing_adapter.pb.cc
)

set_target_properties(old_routing_adapter PROPERTIES
    OUTPUT_NAME "old_routing_adapter"
    PREFIX "lib"
    SUFFIX ".so"
)

target_link_libraries(old_routing_adapter PUBLIC
    cyber
    Eigen3::Eigen
)

target_compile_definitions(old_routing_adapter PRIVATE
    MODULE_NAME="old_routing_adapter"
)

install(TARGETS old_routing_adapter
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(DIRECTORY conf/
    DESTINATION share/external_command/old_routing_adapter/conf
)

install(DIRECTORY dag/
    DESTINATION share/external_command/old_routing_adapter/dag
)

install(DIRECTORY launch/
    DESTINATION share/external_command/old_routing_adapter/launch
)

install(FILES cyberfile.xml
    DESTINATION share/external_command/old_routing_adapter
)
