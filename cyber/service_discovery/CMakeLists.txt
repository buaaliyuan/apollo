# ============================================================================
# cyber/service_discovery/CMakeLists.txt
# Mirrors: cyber/service_discovery/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_service_discovery
    SRCS
        topology_manager.cc
        communication/participant_listener.cc
        communication/subscriber_listener.cc
        container/graph.cc
        container/multi_value_warehouse.cc
        container/single_value_warehouse.cc
        specific_manager/channel_manager.cc
        specific_manager/manager.cc
        specific_manager/node_manager.cc
        specific_manager/service_manager.cc
    HDRS
        topology_manager.h
        communication/participant_listener.h
        communication/subscriber_listener.h
        container/graph.h
        container/multi_value_warehouse.h
        container/single_value_warehouse.h
        container/warehouse_base.h
        specific_manager/channel_manager.h
        specific_manager/manager.h
        specific_manager/node_manager.h
        specific_manager/service_manager.h
    DEPS
        cyber_transport
        cyber_base
        cyber_common
        cyber_binary
        role_attributes_cc_proto
        fastrtps
        cyber_state
        cyber_message
        proto_desc_cc_proto
        topology_change_cc_proto
        cyber_time
)

apollo_cc_library(
    NAME cyber_service_discovery_role
    SRCS role/role.cc
    HDRS role/role.h
    DEPS
        cyber_binary
        cyber_common
        role_attributes_cc_proto
)

apollo_cc_test(NAME topology_manager_test       SRCS topology_manager_test.cc       DEPS cyber)
apollo_cc_test(NAME graph_test                  SRCS container/graph_test.cc        DEPS cyber)
apollo_cc_test(NAME multi_value_warehouse_test  SRCS container/multi_value_warehouse_test.cc  DEPS cyber_service_discovery)
apollo_cc_test(NAME single_value_warehouse_test SRCS container/single_value_warehouse_test.cc DEPS cyber_service_discovery)
apollo_cc_test(NAME role_test                   SRCS role/role_test.cc              DEPS cyber)
apollo_cc_test(NAME channel_manager_test        SRCS specific_manager/channel_manager_test.cc DEPS cyber unit_test_cc_proto)
apollo_cc_test(NAME node_manager_test           SRCS specific_manager/node_manager_test.cc    DEPS cyber)
apollo_cc_test(NAME service_manager_test        SRCS specific_manager/service_manager_test.cc DEPS cyber)
