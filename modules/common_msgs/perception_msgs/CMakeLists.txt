# perception_msgs proto targets
apollo_proto_library(NAME perception_obstacle_cc_proto SRCS perception_obstacle.proto
    DEPS error_code_cc_proto geometry_cc_proto header_cc_proto pnc_point_cc_proto
         map_lane_cc_proto)
apollo_proto_library(NAME perception_camera_cc_proto SRCS perception_camera.proto
    DEPS perception_obstacle_cc_proto geometry_cc_proto header_cc_proto)
apollo_proto_library(NAME perception_lane_cc_proto SRCS perception_lane.proto
    DEPS perception_camera_cc_proto header_cc_proto)
apollo_proto_library(NAME traffic_light_detection_cc_proto SRCS traffic_light_detection.proto
    DEPS header_cc_proto)
apollo_proto_library(NAME perception_benchmark_cc_proto SRCS perception_benchmark.proto
    DEPS perception_obstacle_cc_proto error_code_cc_proto header_cc_proto)
apollo_proto_library(NAME perception_barrier_gate_cc_proto SRCS perception_barrier_gate.proto
    DEPS header_cc_proto)
