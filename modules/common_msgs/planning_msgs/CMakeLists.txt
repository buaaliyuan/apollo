# planning_msgs proto targets
apollo_proto_library(NAME sl_boundary_cc_proto SRCS sl_boundary.proto
    DEPS pnc_point_cc_proto)
apollo_proto_library(NAME planning_pad_msg_cc_proto SRCS pad_msg.proto
    DEPS header_cc_proto)
apollo_proto_library(NAME decision_cc_proto SRCS decision.proto
    DEPS geometry_cc_proto vehicle_signal_cc_proto routing_geometry_cc_proto)
apollo_proto_library(NAME navigation_cc_proto SRCS navigation.proto
    DEPS header_cc_proto pnc_point_cc_proto localization_cc_proto
         map_cc_proto perception_obstacle_cc_proto)
apollo_proto_library(NAME planning_command_cc_proto SRCS planning_command.proto
    DEPS header_cc_proto routing_cc_proto)
apollo_proto_library(NAME planning_internal_cc_proto SRCS planning_internal.proto
    DEPS decision_cc_proto navigation_cc_proto sl_boundary_cc_proto
         geometry_cc_proto header_cc_proto pnc_point_cc_proto
         chassis_cc_proto chart_cc_proto localization_cc_proto
         traffic_light_detection_cc_proto routing_geometry_cc_proto
         routing_cc_proto map_lane_cc_proto)
apollo_proto_library(NAME planning_cc_proto SRCS planning.proto
    DEPS decision_cc_proto planning_internal_cc_proto
         drive_state_cc_proto geometry_cc_proto header_cc_proto
         pnc_point_cc_proto chassis_cc_proto map_id_cc_proto)
