# control_msgs proto targets
apollo_proto_library(NAME input_debug_cc_proto SRCS input_debug.proto
    DEPS header_cc_proto)
apollo_proto_library(NAME control_pad_msg_cc_proto SRCS pad_msg.proto
    DEPS header_cc_proto)
apollo_proto_library(NAME control_interactive_msg_cc_proto SRCS control_interactive_msg.proto
    DEPS header_cc_proto)
apollo_proto_library(NAME control_cmd_cc_proto SRCS control_cmd.proto
    DEPS input_debug_cc_proto control_pad_msg_cc_proto
         drive_state_cc_proto header_cc_proto pnc_point_cc_proto
         vehicle_signal_cc_proto chassis_cc_proto
         geometry_cc_proto vehicle_id_cc_proto)
