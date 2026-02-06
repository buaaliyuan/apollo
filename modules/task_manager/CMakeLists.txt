# ============================================================================
# modules/task_manager/CMakeLists.txt
# ============================================================================

# ── Proto ──
apollo_proto_library(
    NAME task_manager_config_cc_proto
    SRCS proto/task_manager_config.proto
)

# ── apollo_task_manager library ──
apollo_cc_library(
    NAME apollo_task_manager
    SRCS
        common/task_manager_gflags.cc
        cycle_routing_manager.cc
        parking_routing_manager.cc
    HDRS
        common/task_manager_gflags.h
        cycle_routing_manager.h
        parking_routing_manager.h
        task_manager_component.h
    DEPS
        cyber
        monitor_log
        status
        command_status_cc_proto
        lane_follow_command_cc_proto
        localization_cc_proto
        routing_cc_proto
        task_manager_cc_proto
        task_manager_config_cc_proto
        gflags
    COPTS -DMODULE_NAME="task_manager"
)

# ── task_manager_component ──
apollo_component(
    NAME libtask_manager_component.so
    SRCS task_manager_component.cc
    HDRS task_manager_component.h
    DEPS
        apollo_task_manager
        cyber
        command_status_cc_proto
        lane_follow_command_cc_proto
        planning_cc_proto
        routing_cc_proto
        task_manager_config_cc_proto
    COPTS -DMODULE_NAME="task_manager"
)
