# dreamview_msgs proto targets
apollo_proto_library(NAME chart_cc_proto SRCS chart.proto
    DEPS geometry_cc_proto)
apollo_proto_library(NAME hmi_config_cc_proto SRCS hmi_config.proto)
apollo_proto_library(NAME hmi_status_cc_proto SRCS hmi_status.proto
    DEPS geometry_cc_proto header_cc_proto system_status_cc_proto)
apollo_proto_library(NAME hmi_mode_cc_proto SRCS hmi_mode.proto
    DEPS hmi_status_cc_proto)
apollo_proto_library(NAME simulation_world_cc_proto SRCS simulation_world.proto
    DEPS chassis_cc_proto monitor_log_cc_proto pnc_point_cc_proto
         perception_obstacle_cc_proto planning_internal_cc_proto
         feature_cc_proto routing_geometry_cc_proto vehicle_config_cc_proto)
