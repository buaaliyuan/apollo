# ============================================================================
# modules/external_command/CMakeLists.txt
# ============================================================================

# ── Subdirectory protos ──
# process_component proto
apollo_proto_library(
    NAME process_component_config_cc_proto
    SRCS process_component/proto/process_component_config.proto
)

# command_processor_base proto
apollo_proto_library(
    NAME command_processor_config_cc_proto
    SRCS command_processor/command_processor_base/proto/command_processor_config.proto
)

# action_command proto
apollo_proto_library(
    NAME action_command_config_cc_proto
    SRCS command_processor/action_command_processor/proto/action_command_config.proto
)

# external_command_demo protos
apollo_proto_library(
    NAME sweeper_custom_command_cc_proto
    SRCS external_command_demo/proto/sweeper_custom_command.proto
)

apollo_proto_library(
    NAME demo_config_cc_proto
    SRCS external_command_demo/proto/demo_config.proto
)

# old_routing_adapter proto
apollo_proto_library(
    NAME old_routing_adapter_cc_proto
    SRCS old_routing_adapter/proto/old_routing_adapter.proto
)

# ── Base libraries ──
apollo_cc_library(
    NAME message_reader
    SRCS command_processor/command_processor_base/util/message_reader.cc
    HDRS command_processor/command_processor_base/util/message_reader.h
    DEPS cyber
    COPTS -DMODULE_NAME="external_command"
)

apollo_cc_library(
    NAME message_writer
    SRCS command_processor/command_processor_base/util/message_writer.cc
    HDRS command_processor/command_processor_base/util/message_writer.h
    DEPS cyber
    COPTS -DMODULE_NAME="external_command"
)

apollo_cc_library(
    NAME command_processor_base_lib
    SRCS command_processor/command_processor_base/command_processor_base.cc
    HDRS command_processor/command_processor_base/command_processor_base.h
    DEPS
        cyber
        command_status_cc_proto
        command_processor_config_cc_proto
)

apollo_cc_library(
    NAME lane_way_tool
    SRCS command_processor/command_processor_base/util/lane_way_tool.cc
    HDRS command_processor/command_processor_base/util/lane_way_tool.h
    DEPS
        cyber
        adapter_gflags
        external_geometry_cc_proto
        localization_cc_proto
        routing_cc_proto
        message_reader
        apollo_map
    COPTS -DMODULE_NAME="external_command"
)

apollo_cc_library(
    NAME motion_command_processor_base_lib
    HDRS command_processor/command_processor_base/motion_command_processor_base.h
    DEPS
        command_processor_base_lib
        cyber
        message_util
        command_status_cc_proto
        planning_command_cc_proto
        command_processor_config_cc_proto
        lane_way_tool
        message_reader
        message_writer
        apollo_routing
    COPTS -DMODULE_NAME="external_command"
)

# ── process_component ──
apollo_component(
    NAME libexternal_command_process_component.so
    SRCS process_component/external_command_process_component.cc
    HDRS process_component/external_command_process_component.h
    DEPS
        cyber
        config_gflags
        process_component_config_cc_proto
        command_status_cc_proto
        command_processor_base_lib
        command_processor_config_cc_proto
    COPTS -DMODULE_NAME="external_command"
)

# ── old_routing_adapter ──
apollo_component(
    NAME libold_routing_adapter.so
    SRCS old_routing_adapter/old_routing_adapter.cc
    HDRS old_routing_adapter/old_routing_adapter.h
    DEPS
        cyber
        old_routing_adapter_cc_proto
        routing_cc_proto
        apollo_map
        lane_follow_command_cc_proto
        valet_parking_command_cc_proto
        command_status_cc_proto
    COPTS -DMODULE_NAME="old_routing_adapter"
)

# ── Command processor plugins ──
apollo_plugin(
    NAME libaction_command_processor.so
    SRCS command_processor/action_command_processor/action_command_processor.cc
    HDRS command_processor/action_command_processor/action_command_processor.h
    DEPS
        cyber
        command_processor_base_lib
        command_processor_config_cc_proto
        action_command_config_cc_proto
        message_reader
        message_writer
        action_command_cc_proto
        control_pad_msg_cc_proto
        planning_pad_msg_cc_proto
        planning_cc_proto
        chassis_cc_proto
        message_util
    COPTS -DMODULE_NAME="external_command"
)

apollo_plugin(
    NAME libchassis_command_processor.so
    SRCS command_processor/chassis_command_processor/chassis_command_processor.cc
    HDRS command_processor/chassis_command_processor/chassis_command_processor.h
    DEPS
        cyber
        chassis_cc_proto
        chassis_command_cc_proto
        planning_command_cc_proto
        command_processor_base_lib
        message_reader
        message_writer
    COPTS -DMODULE_NAME="external_command_process"
)

apollo_plugin(
    NAME libfree_space_command_processor.so
    SRCS command_processor/free_space_command_processor/free_space_command_processor.cc
    HDRS command_processor/free_space_command_processor/free_space_command_processor.h
    DEPS
        cyber
        free_space_command_cc_proto
        planning_command_cc_proto
        motion_command_processor_base_lib
    COPTS -DMODULE_NAME="external_command_process"
)

apollo_plugin(
    NAME liblane_follow_command_processor.so
    SRCS command_processor/lane_follow_command_processor/lane_follow_command_processor.cc
    HDRS command_processor/lane_follow_command_processor/lane_follow_command_processor.h
    DEPS
        cyber
        motion_command_processor_base_lib
        lane_follow_command_cc_proto
        planning_command_cc_proto
    COPTS -DMODULE_NAME="external_command"
)

apollo_plugin(
    NAME libpath_follow_command_processor.so
    SRCS command_processor/path_follow_command_processor/path_follow_command_processor.cc
    HDRS command_processor/path_follow_command_processor/path_follow_command_processor.h
    DEPS
        cyber
        path_follow_command_cc_proto
        planning_command_cc_proto
        motion_command_processor_base_lib
    COPTS -DMODULE_NAME="external_command_process"
)

apollo_plugin(
    NAME libprecise_parking_command_processor.so
    SRCS command_processor/precise_parking_command_processor/precise_parking_command_processor.cc
    HDRS command_processor/precise_parking_command_processor/precise_parking_command_processor.h
    DEPS
        cyber
        motion_command_processor_base_lib
        precise_parking_command_cc_proto
        planning_command_cc_proto
    COPTS -DMODULE_NAME="external_command"
)

apollo_plugin(
    NAME libspeed_command_processor.so
    SRCS command_processor/speed_command_processor/speed_command_processor.cc
    HDRS command_processor/speed_command_processor/speed_command_processor.h
    DEPS
        cyber
        message_util
        speed_command_cc_proto
        planning_command_cc_proto
        command_processor_base_lib
        message_reader
        message_writer
    COPTS -DMODULE_NAME="external_command_process"
)

apollo_plugin(
    NAME libvalet_parking_command_processor.so
    SRCS command_processor/valet_parking_command_processor/valet_parking_command_processor.cc
    HDRS command_processor/valet_parking_command_processor/valet_parking_command_processor.h
    DEPS
        cyber
        motion_command_processor_base_lib
        valet_parking_command_cc_proto
        planning_command_cc_proto
    COPTS -DMODULE_NAME="external_command"
)

apollo_plugin(
    NAME libzone_cover_command_processor.so
    SRCS command_processor/zone_cover_command_processor/zone_cover_command_processor.cc
    HDRS command_processor/zone_cover_command_processor/zone_cover_command_processor.h
    DEPS
        cyber
        zone_cover_command_cc_proto
        planning_command_cc_proto
        motion_command_processor_base_lib
    COPTS -DMODULE_NAME="external_command_process"
)

# ── Demo components ──
apollo_component(
    NAME libexternal_command_demo_component.so
    SRCS external_command_demo/external_command_demo.cc
    HDRS external_command_demo/external_command_demo.h
    DEPS
        cyber
        message_util
        command_status_cc_proto
        action_command_cc_proto
        chassis_command_cc_proto
        free_space_command_cc_proto
        lane_follow_command_cc_proto
        path_follow_command_cc_proto
        speed_command_cc_proto
        valet_parking_command_cc_proto
        zone_cover_command_cc_proto
        planning_cc_proto
        sweeper_custom_command_cc_proto
        demo_config_cc_proto
    COPTS -DMODULE_NAME="external_command_demo"
)
