# config_msgs proto targets
apollo_proto_library(NAME vehicle_config_cc_proto SRCS vehicle_config.proto
    DEPS geometry_cc_proto header_cc_proto vehicle_id_cc_proto)
