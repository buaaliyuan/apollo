# ============================================================================
# modules/bridge/CMakeLists.txt
# ============================================================================

# ── Proto ──
apollo_proto_library(
    NAME udp_bridge_remote_info_cc_proto
    SRCS proto/udp_bridge_remote_info.proto
)

# ── apollo_bridge_common library ──
apollo_cc_library(
    NAME apollo_bridge_common
    SRCS
        common/bridge_buffer.cc
        common/bridge_gflags.cc
        common/bridge_header.cc
        common/util.cc
    HDRS
        common/bridge_buffer.h
        common/bridge_gflags.h
        common/bridge_header.h
        common/bridge_header_item.h
        common/bridge_proto_diser_buf_factory.h
        common/bridge_proto_diserialized_buf.h
        common/bridge_proto_serialized_buf.h
        common/macro.h
        common/udp_listener.h
        common/util.h
    DEPS
        adapter_gflags
        gflags
)

# ── apollo_udp_bridge library ──
apollo_cc_library(
    NAME apollo_udp_bridge
    DEPS
        apollo_bridge_common
        cyber
        udp_bridge_remote_info_cc_proto
        monitor_log
        common_util
        chassis_cc_proto
        planning_cc_proto
    COPTS -DMODULE_NAME="bridge"
)

# ── Components ──
apollo_component(
    NAME libudp_bridge_sender_component.so
    SRCS udp_bridge_sender_component.cc
    HDRS udp_bridge_sender_component.h
    DEPS apollo_udp_bridge
)

apollo_component(
    NAME libudp_bridge_receiver_component.so
    SRCS udp_bridge_receiver_component.cc
    HDRS udp_bridge_receiver_component.h
    DEPS apollo_udp_bridge
)

apollo_component(
    NAME libudp_bridge_multi_receiver_component.so
    SRCS udp_bridge_multi_receiver_component.cc
    HDRS udp_bridge_multi_receiver_component.h
    DEPS apollo_udp_bridge
)
