# ============================================================================
# cyber/proto/CMakeLists.txt
# Protobuf code generation for CyberRT proto definitions.
# Mirrors: cyber/proto/BUILD
# ============================================================================

# ── Standalone protos (no deps) ──────────────────────────────────

apollo_proto_library(
    NAME clock_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/clock.proto
)

apollo_proto_library(
    NAME perf_conf_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/perf_conf.proto
)

apollo_proto_library(
    NAME proto_desc_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/proto_desc.proto
)

apollo_proto_library(
    NAME record_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/record.proto
)

apollo_proto_library(
    NAME run_mode_conf_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/run_mode_conf.proto
)

apollo_proto_library(
    NAME transport_conf_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/transport_conf.proto
)

apollo_proto_library(
    NAME qos_profile_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/qos_profile.proto
)

apollo_proto_library(
    NAME choreography_conf_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/choreography_conf.proto
)

apollo_proto_library(
    NAME classic_conf_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/classic_conf.proto
)

apollo_proto_library(
    NAME parameter_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/parameter.proto
)

apollo_proto_library(
    NAME unit_test_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/unit_test.proto
)

apollo_proto_library(
    NAME simple_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/simple.proto
)

# ── Protos with dependencies ─────────────────────────────────────

# component_conf depends on qos_profile
apollo_proto_library(
    NAME component_conf_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/component_conf.proto
    DEPS qos_profile_cc_proto
)

# role_attributes depends on qos_profile
apollo_proto_library(
    NAME role_attributes_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/role_attributes.proto
    DEPS qos_profile_cc_proto
)

# topology_change depends on role_attributes
apollo_proto_library(
    NAME topology_change_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/topology_change.proto
    DEPS role_attributes_cc_proto
)

# scheduler_conf depends on choreography_conf and classic_conf
apollo_proto_library(
    NAME scheduler_conf_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/scheduler_conf.proto
    DEPS choreography_conf_cc_proto classic_conf_cc_proto
)

# dag_conf depends on component_conf
apollo_proto_library(
    NAME dag_conf_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/dag_conf.proto
    DEPS component_conf_cc_proto
)

# cyber_conf depends on scheduler_conf, transport_conf, run_mode_conf, perf_conf
apollo_proto_library(
    NAME cyber_conf_cc_proto
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/cyber_conf.proto
    DEPS scheduler_conf_cc_proto transport_conf_cc_proto run_mode_conf_cc_proto perf_conf_cc_proto
)
