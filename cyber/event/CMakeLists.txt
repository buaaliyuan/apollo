# ============================================================================
# cyber/event/CMakeLists.txt
# Mirrors: cyber/event/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_event
    SRCS perf_event_cache.cc
    HDRS perf_event_cache.h perf_event.h
    DEPS
        cyber_state
        cyber_base
        cyber_common
        cyber_time
)
