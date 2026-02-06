# modules/common/adapters
apollo_cc_library(
    NAME adapter_gflags
    SRCS adapter_gflags.cc
    HDRS adapter_gflags.h
    DEPS gflags
)
