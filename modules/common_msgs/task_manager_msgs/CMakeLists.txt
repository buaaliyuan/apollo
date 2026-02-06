# task_manager_msgs proto targets
apollo_proto_library(NAME task_manager_cc_proto SRCS task_manager.proto
    DEPS header_cc_proto routing_cc_proto lane_follow_command_cc_proto)
