# modules/common/vehicle_model
apollo_cc_library(
    NAME vehicle_model
    SRCS vehicle_model.cc
    HDRS vehicle_model.h
    DEPS
        cyber
        config_gflags
        vehicle_config_helper
        vehicle_model_config_cc_proto
        vehicle_state_cc_proto
)
