# ============================================================================
# modules/storytelling/CMakeLists.txt
# ============================================================================

# ── Proto ──
apollo_proto_library(
    NAME storytelling_config_cc_proto
    SRCS proto/storytelling_config.proto
)

# ── apollo_storytelling library ──
apollo_cc_library(
    NAME apollo_storytelling
    SRCS
        frame_manager.cc
        story_tellers/close_to_junction_teller.cc
        common/storytelling_gflags.cc
    HDRS
        frame_manager.h
        story_tellers/base_teller.h
        story_tellers/close_to_junction_teller.h
        common/storytelling_gflags.h
    DEPS
        cyber
        monitor_log
        story_cc_proto
        storytelling_config_cc_proto
        adapter_gflags
        apollo_map
        planning_cc_proto
        gflags
)

# ── storytelling_component ──
apollo_component(
    NAME libstorytelling_component.so
    SRCS storytelling.cc
    HDRS storytelling.h
    DEPS
        cyber
        apollo_storytelling
    COPTS -DMODULE_NAME="storytelling"
)
