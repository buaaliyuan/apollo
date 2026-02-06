# ============================================================================
# cyber/transport/CMakeLists.txt
# Mirrors: cyber/transport/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_transport
    SRCS
        common/endpoint.cc
        common/identity.cc
        dispatcher/dispatcher.cc
        dispatcher/intra_dispatcher.cc
        dispatcher/rtps_dispatcher.cc
        dispatcher/shm_dispatcher.cc
        message/message_info.cc
        qos/qos_profile_conf.cc
        rtps/attributes_filler.cc
        rtps/participant.cc
        rtps/sub_listener.cc
        rtps/underlay_message.cc
        rtps/underlay_message_type.cc
        shm/arena_address_allocator.cc
        shm/block.cc
        shm/condition_notifier.cc
        shm/multicast_notifier.cc
        shm/notifier_factory.cc
        shm/posix_segment.cc
        shm/protobuf_arena_manager.cc
        shm/readable_info.cc
        shm/segment.cc
        shm/segment_factory.cc
        shm/shm_conf.cc
        shm/state.cc
        shm/xsi_segment.cc
        transport.cc
    HDRS
        common/endpoint.h
        common/identity.h
        dispatcher/dispatcher.h
        dispatcher/intra_dispatcher.h
        dispatcher/rtps_dispatcher.h
        dispatcher/shm_dispatcher.h
        message/history.h
        message/history_attributes.h
        message/listener_handler.h
        message/message_info.h
        qos/qos_profile_conf.h
        receiver/hybrid_receiver.h
        receiver/intra_receiver.h
        receiver/receiver.h
        receiver/rtps_receiver.h
        receiver/shm_receiver.h
        rtps/attributes_filler.h
        rtps/participant.h
        rtps/sub_listener.h
        rtps/underlay_message.h
        rtps/underlay_message_type.h
        shm/arena_address_allocator.h
        shm/block.h
        shm/condition_notifier.h
        shm/multicast_notifier.h
        shm/notifier_base.h
        shm/notifier_factory.h
        shm/posix_segment.h
        shm/protobuf_arena_manager.h
        shm/readable_info.h
        shm/segment.h
        shm/segment_factory.h
        shm/shm_conf.h
        shm/state.h
        shm/xsi_segment.h
        transmitter/hybrid_transmitter.h
        transmitter/intra_transmitter.h
        transmitter/rtps_transmitter.h
        transmitter/shm_transmitter.h
        transmitter/transmitter.h
        transport.h
    DEPS
        cyber_base
        cyber_common
        cyber_event
        cyber_message
        proto_desc_cc_proto
        qos_profile_cc_proto
        role_attributes_cc_proto
        cyber_scheduler
        cyber_service_discovery_role
        apollo_statistics
        cyber_task
        fastrtps
        uuid
    LINKOPTS -lrt
)

apollo_cc_test(NAME condition_notifier_test SRCS shm/condition_notifier_test.cc DEPS cyber)
apollo_cc_test(NAME rtps_test               SRCS rtps/rtps_test.cc             DEPS cyber fastrtps)
apollo_cc_test(NAME message_info_test       SRCS message/message_info_test.cc  DEPS cyber)
apollo_cc_test(NAME message_test            SRCS message/message_test.cc       DEPS cyber)
apollo_cc_test(NAME endpoint_test           SRCS common/endpoint_test.cc       DEPS cyber)
apollo_cc_test(NAME identity_test           SRCS common/identity_test.cc       DEPS cyber)
apollo_cc_test(NAME transport_test          SRCS transport_test.cc             DEPS cyber unit_test_cc_proto)
apollo_cc_test(NAME dispatcher_test         SRCS dispatcher/dispatcher_test.cc DEPS cyber unit_test_cc_proto)
apollo_cc_test(NAME intra_dispatcher_test   SRCS dispatcher/intra_dispatcher_test.cc DEPS cyber unit_test_cc_proto)
apollo_cc_test(NAME rtps_dispatcher_test    SRCS dispatcher/rtps_dispatcher_test.cc  DEPS cyber unit_test_cc_proto)
apollo_cc_test(NAME shm_dispatcher_test     SRCS dispatcher/shm_dispatcher_test.cc   DEPS cyber unit_test_cc_proto)
