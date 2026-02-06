# ============================================================================
# modules/drivers/canbus/CMakeLists.txt
# ============================================================================

# ── Proto ──
apollo_proto_library(
    NAME sensor_canbus_conf_cc_proto
    SRCS proto/sensor_canbus_conf.proto
    DEPS can_card_parameter_cc_proto
)

# ── apollo_drivers_canbus library ──
apollo_cc_library(
    NAME apollo_drivers_canbus
    SRCS
        sensor_gflags.cc
        can_client/can_client_factory.cc
        can_client/fake/fake_can_client.cc
        can_client/hermes_can/hermes_can_client.cc
        can_client/socket/socket_can_client_raw.cc
        common/byte.cc
    HDRS
        sensor_gflags.h
        sensor_canbus.h
        can_client/can_client.h
        can_client/can_client_factory.h
        can_client/fake/fake_can_client.h
        can_client/hermes_can/bcan.h
        can_client/hermes_can/bcan_defs.h
        can_client/hermes_can/hermes_can_client.h
        can_client/socket/socket_can_client_raw.h
        can_comm/can_receiver.h
        can_comm/can_sender.h
        can_comm/message_manager.h
        can_comm/protocol_data.h
        common/byte.h
        common/canbus_consts.h
    DEPS
        cyber
        common_util
        monitor_log
        error_code_cc_proto
        can_card_parameter_cc_proto
        gflags
        gtest_headers
        hermes_can
    COPTS -DMODULE_NAME="canbus"
)

# ── can_client_tool binary ──
apollo_cc_binary(
    NAME can_client_tool
    SRCS can_client/can_client_tool.cc
    DEPS
        cyber
        can_card_parameter_cc_proto
        apollo_drivers_canbus
        gflags
)
