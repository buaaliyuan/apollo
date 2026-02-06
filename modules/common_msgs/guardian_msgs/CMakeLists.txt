# guardian_msgs proto targets
apollo_proto_library(NAME guardian_cc_proto SRCS guardian.proto
    DEPS header_cc_proto control_cmd_cc_proto)
