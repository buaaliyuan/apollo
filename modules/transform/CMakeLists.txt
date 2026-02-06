# ============================================================================
# modules/transform/CMakeLists.txt
# ============================================================================

# ── Proto ──
# NOTE: transform_cc_proto already defined in common_msgs/transform_msgs
# Reuse it directly (no need to re-generate)

apollo_proto_library(
    NAME static_transform_conf_cc_proto
    SRCS proto/static_transform_conf.proto
)

# ── apollo_transform library ──
apollo_cc_library(
    NAME apollo_transform
    SRCS
        buffer.cc
        transform_broadcaster.cc
    HDRS
        buffer.h
        buffer_interface.h
        transform_broadcaster.h
    DEPS
        cyber
        adapter_gflags
        transform_cc_proto
        tf2
        absl
    COPTS -DMODULE_NAME="transform"
)

# ── static_transform_component ──
apollo_component(
    NAME libstatic_transform_component.so
    SRCS static_transform_component.cc
    HDRS static_transform_component.h
    DEPS
        apollo_transform
        cyber
        adapter_gflags
        util_tool
        transform_cc_proto
        static_transform_conf_cc_proto
        yaml-cpp
    COPTS -DMODULE_NAME="transform"
)
