# simulation_msgs proto targets
apollo_proto_library(NAME agent_cc_proto SRCS agent.proto)
apollo_proto_library(NAME grading_condition_cc_proto SRCS grading_condition.proto
    DEPS map_geometry_cc_proto)
apollo_proto_library(NAME grading_metric_cc_proto SRCS grading_metric.proto
    DEPS grading_condition_cc_proto)
apollo_proto_library(NAME simulation_scenario_cc_proto SRCS scenario.proto
    DEPS agent_cc_proto grading_metric_cc_proto
         traffic_light_detection_cc_proto planning_pad_msg_cc_proto
         routing_cc_proto)
