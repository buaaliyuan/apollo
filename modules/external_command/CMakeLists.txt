set(EXTERNAL_COMMAND_COMMON_LIBS
	cyberrt
	common_msg
	common
	gflags
)

# command_processor_base libraries
file(GLOB COMMAND_PROCESSOR_BASE_SRCS 
     "command_processor/command_processor_base/command_processor_base.cc" 
     "command_processor/command_processor_base/command_processor_base.h")
add_library(command_processor_base_lib SHARED ${COMMAND_PROCESSOR_BASE_SRCS})
target_compile_definitions(command_processor_base_lib PRIVATE -DMODULE_NAME="external_command")
target_link_libraries(command_processor_base_lib PUBLIC ${EXTERNAL_COMMAND_COMMON_LIBS})
set_target_properties(command_processor_base_lib PROPERTIES POSITION_INDEPENDENT_CODE ON)

# motion_command_processor_base (header-only library)
add_library(motion_command_processor_base_lib INTERFACE)
target_include_directories(motion_command_processor_base_lib INTERFACE 
    ${CMAKE_CURRENT_SOURCE_DIR}/command_processor/command_processor_base)
target_compile_definitions(motion_command_processor_base_lib INTERFACE -DMODULE_NAME="external_command")
target_link_libraries(motion_command_processor_base_lib INTERFACE 
    command_processor_base_lib 
    ${EXTERNAL_COMMAND_COMMON_LIBS})

# command_processor_base/util libraries
file(GLOB LANE_WAY_TOOL_SRCS 
     "command_processor/command_processor_base/util/lane_way_tool.cc" 
     "command_processor/command_processor_base/util/lane_way_tool.h")
add_library(lane_way_tool SHARED ${LANE_WAY_TOOL_SRCS})
target_compile_definitions(lane_way_tool PRIVATE -DMODULE_NAME="external_command")
target_link_libraries(lane_way_tool PUBLIC ${EXTERNAL_COMMAND_COMMON_LIBS})
set_target_properties(lane_way_tool PROPERTIES POSITION_INDEPENDENT_CODE ON)

file(GLOB MESSAGE_READER_SRCS 
     "command_processor/command_processor_base/util/message_reader.cc" 
     "command_processor/command_processor_base/util/message_reader.h")
add_library(message_reader SHARED ${MESSAGE_READER_SRCS})
target_compile_definitions(message_reader PRIVATE -DMODULE_NAME="external_command")
target_link_libraries(message_reader PUBLIC ${EXTERNAL_COMMAND_COMMON_LIBS})
set_target_properties(message_reader PROPERTIES POSITION_INDEPENDENT_CODE ON)

file(GLOB MESSAGE_WRITER_SRCS 
     "command_processor/command_processor_base/util/message_writer.cc" 
     "command_processor/command_processor_base/util/message_writer.h")
add_library(message_writer SHARED ${MESSAGE_WRITER_SRCS})
target_compile_definitions(message_writer PRIVATE -DMODULE_NAME="external_command")
target_link_libraries(message_writer PUBLIC ${EXTERNAL_COMMAND_COMMON_LIBS})
set_target_properties(message_writer PROPERTIES POSITION_INDEPENDENT_CODE ON)

# process_component
file(GLOB_RECURSE PROCESS_COMPONENT_SRCS 
     "process_component/*.cc" 
     "process_component/*.h" 
     "process_component/proto/*.cc" 
     "process_component/proto/*.h")
list(FILTER PROCESS_COMPONENT_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(external_command_process_component SHARED ${PROCESS_COMPONENT_SRCS})
target_compile_definitions(external_command_process_component PRIVATE -DMODULE_NAME="external_command")
target_link_libraries(external_command_process_component PUBLIC 
    ${EXTERNAL_COMMAND_COMMON_LIBS} 
    command_processor_base_lib)
set_target_properties(external_command_process_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# old_routing_adapter
file(GLOB_RECURSE OLD_ROUTING_ADAPTER_SRCS 
     "old_routing_adapter/*.cc" 
     "old_routing_adapter/*.h" 
     "old_routing_adapter/proto/*.cc" 
     "old_routing_adapter/proto/*.h")
list(FILTER OLD_ROUTING_ADAPTER_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(old_routing_adapter SHARED ${OLD_ROUTING_ADAPTER_SRCS})
target_compile_definitions(old_routing_adapter PRIVATE -DMODULE_NAME="old_routing_adapter")
target_link_libraries(old_routing_adapter PUBLIC ${EXTERNAL_COMMAND_COMMON_LIBS})
set_target_properties(old_routing_adapter PROPERTIES POSITION_INDEPENDENT_CODE ON)

# external_command_demo
file(GLOB EXTERNAL_COMMAND_DEMO_SRCS 
     "external_command_demo/external_command_demo.cc" 
     "external_command_demo/external_command_demo.h")
file(GLOB_RECURSE EXTERNAL_COMMAND_DEMO_PROTO_SRCS 
     "external_command_demo/proto/*.cc" 
     "external_command_demo/proto/*.h")
add_library(external_command_demo_component SHARED 
    ${EXTERNAL_COMMAND_DEMO_SRCS} 
    ${EXTERNAL_COMMAND_DEMO_PROTO_SRCS})
target_compile_definitions(external_command_demo_component PRIVATE -DMODULE_NAME="external_command_demo")
target_link_libraries(external_command_demo_component PUBLIC ${EXTERNAL_COMMAND_COMMON_LIBS})
set_target_properties(external_command_demo_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

file(GLOB EXTERNAL_COMMAND_WRAPPER_DEMO_SRCS 
     "external_command_demo/external_command_wrapper_demo.cc" 
     "external_command_demo/external_command_wrapper_demo.h")
add_library(external_command_wrapper_demo_component SHARED 
    ${EXTERNAL_COMMAND_WRAPPER_DEMO_SRCS} 
    ${EXTERNAL_COMMAND_DEMO_PROTO_SRCS})
target_compile_definitions(external_command_wrapper_demo_component PRIVATE -DMODULE_NAME="external_command_demo")
target_link_libraries(external_command_wrapper_demo_component PUBLIC ${EXTERNAL_COMMAND_COMMON_LIBS})
set_target_properties(external_command_wrapper_demo_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# command processors (plugins)

# action_command_processor
file(GLOB_RECURSE ACTION_COMMAND_PROCESSOR_SRCS 
     "command_processor/action_command_processor/*.cc" 
     "command_processor/action_command_processor/*.h" 
     "command_processor/action_command_processor/proto/*.cc" 
     "command_processor/action_command_processor/proto/*.h")
list(FILTER ACTION_COMMAND_PROCESSOR_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(action_command_processor SHARED ${ACTION_COMMAND_PROCESSOR_SRCS})
target_compile_definitions(action_command_processor PRIVATE -DMODULE_NAME="external_command")
target_link_libraries(action_command_processor PUBLIC 
    ${EXTERNAL_COMMAND_COMMON_LIBS} 
    command_processor_base_lib 
    message_reader 
    message_writer)
set_target_properties(action_command_processor PROPERTIES POSITION_INDEPENDENT_CODE ON)

# chassis_command_processor
file(GLOB CHASSIS_COMMAND_PROCESSOR_SRCS 
     "command_processor/chassis_command_processor/chassis_command_processor.cc" 
     "command_processor/chassis_command_processor/chassis_command_processor.h")
add_library(chassis_command_processor SHARED ${CHASSIS_COMMAND_PROCESSOR_SRCS})
target_compile_definitions(chassis_command_processor PRIVATE -DMODULE_NAME="external_command_process")
target_link_libraries(chassis_command_processor PUBLIC 
    ${EXTERNAL_COMMAND_COMMON_LIBS} 
    command_processor_base_lib 
    message_reader 
    message_writer)
set_target_properties(chassis_command_processor PROPERTIES POSITION_INDEPENDENT_CODE ON)

# free_space_command_processor
file(GLOB FREE_SPACE_COMMAND_PROCESSOR_SRCS 
     "command_processor/free_space_command_processor/free_space_command_processor.cc" 
     "command_processor/free_space_command_processor/free_space_command_processor.h")
add_library(free_space_command_processor SHARED ${FREE_SPACE_COMMAND_PROCESSOR_SRCS})
target_compile_definitions(free_space_command_processor PRIVATE -DMODULE_NAME="external_command_process")
target_link_libraries(free_space_command_processor PUBLIC 
    ${EXTERNAL_COMMAND_COMMON_LIBS} 
    motion_command_processor_base_lib)
set_target_properties(free_space_command_processor PROPERTIES POSITION_INDEPENDENT_CODE ON)

# lane_follow_command_processor
file(GLOB LANE_FOLLOW_COMMAND_PROCESSOR_SRCS 
     "command_processor/lane_follow_command_processor/lane_follow_command_processor.cc" 
     "command_processor/lane_follow_command_processor/lane_follow_command_processor.h")
add_library(lane_follow_command_processor SHARED ${LANE_FOLLOW_COMMAND_PROCESSOR_SRCS})
target_compile_definitions(lane_follow_command_processor PRIVATE -DMODULE_NAME="external_command")
target_link_libraries(lane_follow_command_processor PUBLIC 
    ${EXTERNAL_COMMAND_COMMON_LIBS} 
    motion_command_processor_base_lib)
set_target_properties(lane_follow_command_processor PROPERTIES POSITION_INDEPENDENT_CODE ON)

# path_follow_command_processor
file(GLOB PATH_FOLLOW_COMMAND_PROCESSOR_SRCS 
     "command_processor/path_follow_command_processor/path_follow_command_processor.cc" 
     "command_processor/path_follow_command_processor/path_follow_command_processor.h")
add_library(path_follow_command_processor SHARED ${PATH_FOLLOW_COMMAND_PROCESSOR_SRCS})
target_compile_definitions(path_follow_command_processor PRIVATE -DMODULE_NAME="external_command")
target_link_libraries(path_follow_command_processor PUBLIC 
    ${EXTERNAL_COMMAND_COMMON_LIBS} 
    motion_command_processor_base_lib)
set_target_properties(path_follow_command_processor PROPERTIES POSITION_INDEPENDENT_CODE ON)

# precise_parking_command_processor
file(GLOB PRECISE_PARKING_COMMAND_PROCESSOR_SRCS 
     "command_processor/precise_parking_command_processor/precise_parking_command_processor.cc" 
     "command_processor/precise_parking_command_processor/precise_parking_command_processor.h")
add_library(precise_parking_command_processor SHARED ${PRECISE_PARKING_COMMAND_PROCESSOR_SRCS})
target_compile_definitions(precise_parking_command_processor PRIVATE -DMODULE_NAME="external_command")
target_link_libraries(precise_parking_command_processor PUBLIC 
    ${EXTERNAL_COMMAND_COMMON_LIBS} 
    motion_command_processor_base_lib)
set_target_properties(precise_parking_command_processor PROPERTIES POSITION_INDEPENDENT_CODE ON)

# speed_command_processor
file(GLOB SPEED_COMMAND_PROCESSOR_SRCS 
     "command_processor/speed_command_processor/speed_command_processor.cc" 
     "command_processor/speed_command_processor/speed_command_processor.h")
add_library(speed_command_processor SHARED ${SPEED_COMMAND_PROCESSOR_SRCS})
target_compile_definitions(speed_command_processor PRIVATE -DMODULE_NAME="external_command_process")
target_link_libraries(speed_command_processor PUBLIC 
    ${EXTERNAL_COMMAND_COMMON_LIBS} 
    command_processor_base_lib 
    message_reader 
    message_writer)
set_target_properties(speed_command_processor PROPERTIES POSITION_INDEPENDENT_CODE ON)

# valet_parking_command_processor
file(GLOB VALET_PARKING_COMMAND_PROCESSOR_SRCS 
     "command_processor/valet_parking_command_processor/valet_parking_command_processor.cc" 
     "command_processor/valet_parking_command_processor/valet_parking_command_processor.h")
add_library(valet_parking_command_processor SHARED ${VALET_PARKING_COMMAND_PROCESSOR_SRCS})
target_compile_definitions(valet_parking_command_processor PRIVATE -DMODULE_NAME="external_command")
target_link_libraries(valet_parking_command_processor PUBLIC 
    ${EXTERNAL_COMMAND_COMMON_LIBS} 
    motion_command_processor_base_lib)
set_target_properties(valet_parking_command_processor PROPERTIES POSITION_INDEPENDENT_CODE ON)

# zone_cover_command_processor
file(GLOB ZONE_COVER_COMMAND_PROCESSOR_SRCS 
     "command_processor/zone_cover_command_processor/zone_cover_command_processor.cc" 
     "command_processor/zone_cover_command_processor/zone_cover_command_processor.h")
add_library(zone_cover_command_processor SHARED ${ZONE_COVER_COMMAND_PROCESSOR_SRCS})
target_compile_definitions(zone_cover_command_processor PRIVATE -DMODULE_NAME="external_command")
target_link_libraries(zone_cover_command_processor PUBLIC 
    ${EXTERNAL_COMMAND_COMMON_LIBS} 
    motion_command_processor_base_lib)
set_target_properties(zone_cover_command_processor PROPERTIES POSITION_INDEPENDENT_CODE ON)
