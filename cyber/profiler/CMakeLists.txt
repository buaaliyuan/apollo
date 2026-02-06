# ============================================================================
# cyber/profiler/CMakeLists.txt
# Mirrors: cyber/profiler/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_profiler
    SRCS
        block_manager.cc
        block.cc
        frame.cc
    HDRS
        profiler.h
        block_manager.h
        block.h
        frame.h
    DEPS
        cyber_common
        cyber_croutine
)

apollo_cc_test(NAME profiler_test SRCS profiler_test.cc DEPS cyber_profiler)
