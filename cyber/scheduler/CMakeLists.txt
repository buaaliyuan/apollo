# ============================================================================
# cyber/scheduler/CMakeLists.txt
# Mirrors: cyber/scheduler/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_scheduler
    SRCS
        processor.cc
        processor_context.cc
        scheduler.cc
        scheduler_factory.cc
        common/pin_thread.cc
        policy/choreography_context.cc
        policy/classic_context.cc
        policy/scheduler_choreography.cc
        policy/scheduler_classic.cc
    HDRS
        processor.h
        processor_context.h
        scheduler.h
        scheduler_factory.h
        common/cv_wrapper.h
        common/mutex_wrapper.h
        common/pin_thread.h
        policy/choreography_context.h
        policy/classic_context.h
        policy/scheduler_choreography.h
        policy/scheduler_classic.h
    DEPS
        cyber_croutine
        cyber_data
        cyber_common
        cyber_time
        component_conf_cc_proto
        choreography_conf_cc_proto
        classic_conf_cc_proto
)

apollo_cc_test(NAME scheduler_test        SRCS scheduler_test.cc        DEPS cyber)
apollo_cc_test(NAME scheduler_classic_test SRCS scheduler_classic_test.cc DEPS cyber)
apollo_cc_test(NAME scheduler_choreo_test  SRCS scheduler_choreo_test.cc  DEPS cyber)
apollo_cc_test(NAME processor_test        SRCS processor_test.cc        DEPS cyber)
apollo_cc_test(NAME pin_thread_test       SRCS common/pin_thread_test.cc DEPS cyber)
