# ============================================================================
# cyber/timer/CMakeLists.txt
# Mirrors: cyber/timer/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_timer
    SRCS
        timer.cc
        timing_wheel.cc
    HDRS
        timer.h
        timer_task.h
        timer_bucket.h
        timing_wheel.h
    DEPS
        cyber_common
        cyber_task
        cyber_time
)

apollo_cc_test(NAME timer_test SRCS timer_test.cc DEPS cyber)
