# routing_msgs proto targets
apollo_proto_library(NAME routing_geometry_cc_proto SRCS geometry.proto
    DEPS geometry_cc_proto)
apollo_proto_library(NAME poi_cc_proto SRCS poi.proto
    DEPS routing_geometry_cc_proto geometry_cc_proto map_geometry_cc_proto)
apollo_proto_library(NAME routing_cc_proto SRCS routing.proto
    DEPS routing_geometry_cc_proto poi_cc_proto error_code_cc_proto header_cc_proto)
