# basic_msgs proto targets
apollo_proto_library(NAME error_code_cc_proto SRCS error_code.proto)
apollo_proto_library(NAME geometry_cc_proto SRCS geometry.proto)
apollo_proto_library(NAME direction_cc_proto SRCS direction.proto)
apollo_proto_library(NAME pnc_point_cc_proto SRCS pnc_point.proto)
apollo_proto_library(NAME drive_state_cc_proto SRCS drive_state.proto)
apollo_proto_library(NAME vehicle_signal_cc_proto SRCS vehicle_signal.proto)
apollo_proto_library(NAME vehicle_id_cc_proto SRCS vehicle_id.proto)
apollo_proto_library(NAME header_cc_proto SRCS header.proto DEPS error_code_cc_proto)
apollo_proto_library(NAME drive_event_cc_proto SRCS drive_event.proto
    DEPS header_cc_proto pose_cc_proto)
