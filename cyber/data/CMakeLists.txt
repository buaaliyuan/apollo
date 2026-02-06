# ============================================================================
# cyber/data/CMakeLists.txt
# Header-only library. Mirrors: cyber/data/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_data
    INTERFACE
    HDRS
        cache_buffer.h
        channel_buffer.h
        data_dispatcher.h
        data_notifier.h
        data_visitor.h
        data_visitor_base.h
        fusion/all_latest.h
        fusion/data_fusion.h
    DEPS
        component_conf_cc_proto
)

apollo_cc_test(NAME cache_buffer_test    SRCS cache_buffer_test.cc    DEPS cyber_data)
apollo_cc_test(NAME data_visitor_test    SRCS data_visitor_test.cc    DEPS cyber)
apollo_cc_test(NAME data_dispatcher_test SRCS data_dispatcher_test.cc DEPS cyber)
apollo_cc_test(NAME channel_buffer_test  SRCS channel_buffer_test.cc  DEPS cyber)
apollo_cc_test(NAME all_latest_test      SRCS fusion/all_latest_test.cc DEPS cyber)
