file(GLOB_RECURSE CPPS "common/*.cc")
file(GLOB_RECURSE HPPS "common/*.h")
list(FILTER CPPS EXCLUDE REGEX ".*_test.cc$")

add_library(bridge_common SHARED 
    ${CPPS} ${HPPS}
)
target_link_libraries(bridge_common PUBLIC
    cyberrt
)

add_library(udp_bridge_multi_receiver_component MODULE
    udp_bridge_multi_receiver_component.cc
    udp_bridge_multi_receiver_component.h    
)
target_link_libraries(udp_bridge_multi_receiver_component PUBLIC 
    bridge_common
    absl::strings
)
target_include_directories(udp_bridge_multi_receiver_component PUBLIC
    ${PROJECT_SOURCE_DIR}
)
set_target_properties(udp_bridge_multi_receiver_component 
    PROPERTIES POSITION_INDEPENDENT_CODE ON
)

add_library(udp_bridge_receiver_component MODULE
    udp_bridge_receiver_component.cc
    udp_bridge_receiver_component.h    
)
target_link_libraries(udp_bridge_receiver_component PUBLIC 
    bridge_common
    absl::strings
)
target_include_directories(udp_bridge_receiver_component PUBLIC
    ${PROJECT_SOURCE_DIR}
)
set_target_properties(udp_bridge_receiver_component 
    PROPERTIES POSITION_INDEPENDENT_CODE ON
)

add_library(udp_bridge_sender_component MODULE
    udp_bridge_sender_component.cc
    udp_bridge_sender_component.h    
)
target_link_libraries(udp_bridge_sender_component PUBLIC 
    bridge_common
    absl::strings
)
target_include_directories(udp_bridge_sender_component PUBLIC
    ${PROJECT_SOURCE_DIR}
)
set_target_properties(udp_bridge_sender_component 
    PROPERTIES POSITION_INDEPENDENT_CODE ON
)