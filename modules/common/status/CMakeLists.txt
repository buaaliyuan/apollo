# modules/common/status
apollo_cc_library(
    NAME status
    HDRS status.h
    DEPS
        util_tool
        error_code_cc_proto
        protobuf::libprotobuf
    INTERFACE
)
