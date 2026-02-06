# modules/common/monitor_log
apollo_cc_library(
    NAME monitor_log
    SRCS
        monitor_log_buffer.cc
        monitor_logger.cc
    HDRS
        monitor_log_buffer.h
        monitor_logger.h
    DEPS
        cyber
        util_tool
        monitor_log_cc_proto
        absl
        gtest_headers
)
