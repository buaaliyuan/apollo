# ============================================================================
# cyber/message/CMakeLists.txt
# Mirrors: cyber/message/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_message
    SRCS
        protobuf_factory.cc
    HDRS
        arena_manager_base.h
        arena_message_wrapper.h
        message_header.h
        message_traits.h
        protobuf_factory.h
        protobuf_traits.h
        py_message.h
        py_message_traits.h
        raw_message.h
        raw_message_traits.h
    DEPS
        cyber_common
        proto_desc_cc_proto
)

apollo_cc_test(NAME message_header_test    SRCS message_header_test.cc    DEPS cyber)
apollo_cc_test(NAME message_traits_test    SRCS message_traits_test.cc    DEPS cyber unit_test_cc_proto)
apollo_cc_test(NAME raw_message_test       SRCS raw_message_test.cc       DEPS cyber)
apollo_cc_test(NAME protobuf_factory_test  SRCS protobuf_factory_test.cc  DEPS cyber unit_test_cc_proto)
