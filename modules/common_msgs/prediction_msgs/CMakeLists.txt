# prediction_msgs proto targets
apollo_proto_library(NAME prediction_point_cc_proto SRCS prediction_point.proto)
apollo_proto_library(NAME prediction_scenario_cc_proto SRCS scenario.proto)
apollo_proto_library(NAME lane_graph_cc_proto SRCS lane_graph.proto
    DEPS geometry_cc_proto pnc_point_cc_proto map_lane_cc_proto)
apollo_proto_library(NAME feature_cc_proto SRCS feature.proto
    DEPS lane_graph_cc_proto prediction_point_cc_proto
         geometry_cc_proto pnc_point_cc_proto map_lane_cc_proto
         perception_obstacle_cc_proto)
apollo_proto_library(NAME prediction_obstacle_cc_proto SRCS prediction_obstacle.proto
    DEPS feature_cc_proto prediction_scenario_cc_proto
         error_code_cc_proto header_cc_proto perception_obstacle_cc_proto)
