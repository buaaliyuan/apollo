# v2x_msgs proto targets
apollo_proto_library(NAME v2x_traffic_light_cc_proto SRCS v2x_traffic_light.proto
    DEPS direction_cc_proto header_cc_proto)
