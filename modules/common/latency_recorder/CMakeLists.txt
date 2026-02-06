# modules/common/latency_recorder
apollo_cc_library(
    NAME latency_recorder
    SRCS latency_recorder.cc
    HDRS latency_recorder.h
    DEPS
        cyber
        adapter_gflags
        latency_record_cc_proto
        util_tool
)
