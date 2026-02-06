# modules/common/vehicle_state/proto
apollo_proto_library(NAME vehicle_state_cc_proto SRCS vehicle_state.proto
    DEPS chassis_cc_proto pose_cc_proto)
