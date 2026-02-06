# ============================================================================
# cyber/base/CMakeLists.txt
# Header-only library. Mirrors: cyber/base/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_base
    INTERFACE
    HDRS
        arena_queue.h
        atomic_hash_map.h
        atomic_rw_lock.h
        bounded_queue.h
        concurrent_object_pool.h
        for_each.h
        macros.h
        object_pool.h
        pthread_rw_lock.h
        reentrant_rw_lock.h
        rw_lock_guard.h
        signal.h
        thread_pool.h
        thread_safe_queue.h
        unbounded_queue.h
        wait_strategy.h
)

# Tests
apollo_cc_test(NAME atomic_hash_map_test SRCS atomic_hash_map_test.cc DEPS cyber_base)
apollo_cc_test(NAME atomic_rw_lock_test  SRCS atomic_rw_lock_test.cc  DEPS cyber_base)
apollo_cc_test(NAME bounded_queue_test   SRCS bounded_queue_test.cc   DEPS cyber_base)
apollo_cc_test(NAME for_each_test        SRCS for_each_test.cc        DEPS cyber_base)
apollo_cc_test(NAME object_pool_test     SRCS object_pool_test.cc     DEPS cyber_base LINKOPTS -latomic)
apollo_cc_test(NAME signal_test          SRCS signal_test.cc          DEPS cyber_base)
apollo_cc_test(NAME unbounded_queue_test SRCS unbounded_queue_test.cc DEPS cyber_base)
