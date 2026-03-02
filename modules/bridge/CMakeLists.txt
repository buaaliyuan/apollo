add_library(bridge_common SHARED)
target_sources(bridge_common
PRIVATE
    common/bridge_buffer.cc
    common/bridge_gflags.cc
    common/bridge_header.cc
    common/util.cc
    proto/udp_bridge_remote_info.pb.cc
)
target_compile_definitions(bridge_common
PUBLIC
    MODULE_NAME="bridge"
)

target_link_libraries(bridge_common
PUBLIC
    cyber
    msg_proto
    modules_common
)

add_library(udp_bridge_sender_component SHARED)
target_sources(udp_bridge_sender_component
PRIVATE
    udp_bridge_sender_component.cc
)
target_link_libraries(udp_bridge_sender_component
PUBLIC
    bridge_common
)

add_library(udp_bridge_receiver_component SHARED)
target_sources(udp_bridge_receiver_component
PRIVATE
    udp_bridge_receiver_component.cc
)
target_link_libraries(udp_bridge_receiver_component
PUBLIC
    bridge_common
)

add_library(udp_bridge_multi_receiver_component SHARED)
target_sources(udp_bridge_multi_receiver_component
PRIVATE
    udp_bridge_multi_receiver_component.cc
)
target_link_libraries(udp_bridge_multi_receiver_component
PUBLIC
    bridge_common
)

install(TARGETS bridge_common udp_bridge_sender_component udp_bridge_receiver_component udp_bridge_multi_receiver_component
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)