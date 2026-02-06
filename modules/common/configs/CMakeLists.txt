# modules/common/configs
apollo_cc_library(
    NAME config_gflags
    SRCS config_gflags.cc
    HDRS config_gflags.h
    DEPS gflags
)

apollo_cc_library(
    NAME vehicle_config_helper
    SRCS vehicle_config_helper.cc
    HDRS vehicle_config_helper.h
    DEPS
        config_gflags
        cyber
        common_math
        pnc_point_cc_proto
        vehicle_config_cc_proto
)
