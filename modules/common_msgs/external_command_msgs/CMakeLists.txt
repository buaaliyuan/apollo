# external_command_msgs proto targets
apollo_proto_library(NAME lane_segment_cc_proto SRCS lane_segment.proto)
apollo_proto_library(NAME external_geometry_cc_proto SRCS geometry.proto)
apollo_proto_library(NAME command_status_cc_proto SRCS command_status.proto
    DEPS header_cc_proto)
apollo_proto_library(NAME action_command_cc_proto SRCS action_command.proto
    DEPS header_cc_proto)
apollo_proto_library(NAME speed_command_cc_proto SRCS speed_command.proto
    DEPS header_cc_proto)
apollo_proto_library(NAME chassis_command_cc_proto SRCS chassis_command.proto
    DEPS header_cc_proto vehicle_signal_cc_proto)
apollo_proto_library(NAME lane_follow_command_cc_proto SRCS lane_follow_command.proto
    DEPS external_geometry_cc_proto lane_segment_cc_proto header_cc_proto)
apollo_proto_library(NAME path_follow_command_cc_proto SRCS path_follow_command.proto
    DEPS external_geometry_cc_proto header_cc_proto)
apollo_proto_library(NAME precise_parking_command_cc_proto SRCS precise_parking_command.proto
    DEPS external_geometry_cc_proto header_cc_proto)
apollo_proto_library(NAME valet_parking_command_cc_proto SRCS valet_parking_command.proto
    DEPS external_geometry_cc_proto lane_segment_cc_proto header_cc_proto)
apollo_proto_library(NAME free_space_command_cc_proto SRCS free_space_command.proto
    DEPS external_geometry_cc_proto header_cc_proto)
apollo_proto_library(NAME zone_cover_command_cc_proto SRCS zone_cover_command.proto
    DEPS external_geometry_cc_proto header_cc_proto)
