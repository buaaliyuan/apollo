# ============================================================================
# cyber/node/CMakeLists.txt
# Mirrors: cyber/node/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_node
    SRCS
        node.cc
    HDRS
        node.h
        node_channel_impl.h
        node_service_impl.h
        reader.h
        reader_base.h
        writer.h
        writer_base.h
    DEPS
        cyber_blocker
        cyber_common
        cyber_message
        run_mode_conf_cc_proto
        cyber_service
        cyber_service_discovery
        cyber_croutine
        cyber_data
        topology_change_cc_proto
        cyber_scheduler
        cyber_time
        cyber_transport
        cyber_event
        role_attributes_cc_proto
    LINKOPTS -lbvar
)

apollo_cc_test(NAME node_channel_impl_test SRCS node_channel_impl_test.cc DEPS cyber unit_test_cc_proto)
apollo_cc_test(NAME node_test              SRCS node_test.cc              DEPS cyber unit_test_cc_proto)
apollo_cc_test(NAME reader_test            SRCS reader_test.cc            DEPS cyber unit_test_cc_proto)
apollo_cc_test(NAME writer_reader_test     SRCS writer_reader_test.cc     DEPS cyber unit_test_cc_proto)
apollo_cc_test(NAME writer_test            SRCS writer_test.cc            DEPS cyber unit_test_cc_proto)
