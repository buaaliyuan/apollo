# ============================================================================
# modules/canbus/CMakeLists.txt
# ============================================================================

# ── Proto ──
apollo_proto_library(
    NAME vehicle_parameter_cc_proto
    SRCS proto/vehicle_parameter.proto
    DEPS
        chassis_cc_proto
        vehicle_config_cc_proto
)

apollo_proto_library(
    NAME canbus_conf_cc_proto
    SRCS proto/canbus_conf.proto
    DEPS
        vehicle_parameter_cc_proto
        can_card_parameter_cc_proto
)

# ── apollo_canbus library ──
apollo_cc_library(
    NAME apollo_canbus
    SRCS
        common/canbus_gflags.cc
        vehicle/abstract_vehicle_factory.cc
    HDRS
        common/canbus_gflags.h
        vehicle/abstract_vehicle_factory.h
        vehicle/vehicle_controller.h
    DEPS
        cyber
        canbus_conf_cc_proto
        vehicle_parameter_cc_proto
        adapter_gflags
        vehicle_config_helper
        monitor_log
        status
        error_code_cc_proto
        chassis_cc_proto
        control_cmd_cc_proto
        chassis_command_cc_proto
        guardian_cc_proto
        apollo_drivers_canbus
        gflags
    COPTS -DMODULE_NAME="canbus"
)

# ── canbus_component ──
apollo_component(
    NAME libcanbus_component.so
    SRCS canbus_component.cc
    HDRS canbus_component.h
    DEPS
        apollo_canbus
        cyber
        adapter_gflags
        monitor_log
        status
        guardian_cc_proto
        apollo_drivers_canbus
        gflags
    COPTS -DMODULE_NAME="canbus"
)

# ── Tools ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/tools/canbus_tester.cc")
    apollo_cc_binary(
        NAME canbus_tester
        SRCS tools/canbus_tester.cc
        DEPS
            cyber
            apollo_canbus
            control_cmd_cc_proto
            adapter_gflags
            gflags
    )
endif()

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/tools/teleop.cc")
    apollo_cc_binary(
        NAME teleop
        SRCS tools/teleop.cc
        DEPS
            cyber
            apollo_canbus
            chassis_cc_proto
            control_cmd_cc_proto
            adapter_gflags
            vehicle_config_helper
            util_tool
    )
endif()
