# ============================================================================
# cyber/component/CMakeLists.txt
# Mirrors: cyber/component/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_component
    SRCS
        timer_component.cc
    HDRS
        component.h
        timer_component.h
        component_base.h
    DEPS
        cyber_scheduler
        cyber_blocker
        cyber_timer
        cyber_transport
        cyber_base
        cyber_class_loader
        cyber_node
        gflags
)

apollo_cc_test(NAME component_test       SRCS component_test.cc       DEPS cyber)
apollo_cc_test(NAME timer_component_test SRCS timer_component_test.cc DEPS cyber)
