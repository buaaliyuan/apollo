# ============================================================================
# modules/guardian/CMakeLists.txt
# ============================================================================

# ── Proto ──
apollo_proto_library(
    NAME guardian_conf_cc_proto
    SRCS proto/guardian_conf.proto
)

# ── guardian_component ──
apollo_component(
    NAME libguardian_component.so
    SRCS guardian_component.cc
    HDRS guardian_component.h
    DEPS
        cyber
        chassis_cc_proto
        adapter_gflags
        util_tool
        control_cmd_cc_proto
        guardian_cc_proto
        guardian_conf_cc_proto
        system_status_cc_proto
    COPTS -DMODULE_NAME="guardian"
)
