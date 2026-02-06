# modules/common/vehicle_state
apollo_cc_library(
    NAME vehicle_state_provider
    SRCS vehicle_state_provider.cc
    HDRS vehicle_state_provider.h
    DEPS
        cyber
        config_gflags
        common_math
        status
        vehicle_state_cc_proto
        chassis_cc_proto
        localization_cc_proto
        absl
        eigen
)
