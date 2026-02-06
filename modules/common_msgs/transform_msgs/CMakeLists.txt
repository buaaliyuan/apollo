# transform_msgs proto targets
apollo_proto_library(NAME transform_cc_proto SRCS transform.proto
    DEPS geometry_cc_proto header_cc_proto)
