# chassis_msgs proto targets
apollo_proto_library(NAME chassis_cc_proto SRCS chassis.proto
    DEPS drive_state_cc_proto geometry_cc_proto header_cc_proto
         vehicle_id_cc_proto vehicle_signal_cc_proto)
apollo_proto_library(NAME chassis_detail_cc_proto SRCS chassis_detail.proto
    DEPS chassis_cc_proto vehicle_id_cc_proto)
