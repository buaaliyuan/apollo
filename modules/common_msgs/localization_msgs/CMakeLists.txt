# localization_msgs proto targets
apollo_proto_library(NAME pose_cc_proto SRCS pose.proto DEPS geometry_cc_proto)
apollo_proto_library(NAME localization_status_cc_proto SRCS localization_status.proto)
apollo_proto_library(NAME localization_imu_cc_proto SRCS imu.proto
    DEPS pose_cc_proto header_cc_proto)
apollo_proto_library(NAME gps_cc_proto SRCS gps.proto
    DEPS pose_cc_proto header_cc_proto)
apollo_proto_library(NAME localization_cc_proto SRCS localization.proto
    DEPS localization_status_cc_proto pose_cc_proto
         geometry_cc_proto header_cc_proto pnc_point_cc_proto)
