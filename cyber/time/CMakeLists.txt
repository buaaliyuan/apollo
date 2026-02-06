# ============================================================================
# cyber/time/CMakeLists.txt
# Mirrors: cyber/time/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_time
    SRCS
        clock.cc
        duration.cc
        rate.cc
        time.cc
    HDRS
        clock.h
        duration.h
        rate.h
        time.h
    DEPS
        cyber_common
        cyber_base
        run_mode_conf_cc_proto
)

apollo_cc_test(NAME time_test     SRCS time_test.cc     DEPS cyber_time)
apollo_cc_test(NAME duration_test SRCS duration_test.cc DEPS cyber_time)
apollo_cc_test(NAME clock_test    SRCS clock_test.cc    DEPS cyber_time)
