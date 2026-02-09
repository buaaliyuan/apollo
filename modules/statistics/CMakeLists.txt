# ============================================================================
# modules/statistics/CMakeLists.txt
# Runtime statistics components (latency, process, resource)
# ============================================================================

# ── Latency statistic ──
apollo_component(
    NAME liblatency_statistic_component.so
    SRCS
        latency/latency_statistic_component.cc
        latency/latency_statistic_gflags.cc
    DEPS
        cyber
        common_util
        adapter_gflags
        latency_statistic_cc_proto
        pointcloud_cc_proto
        perception_obstacle_cc_proto
        prediction_obstacle_cc_proto
        planning_cc_proto
        control_cmd_cc_proto
    COPTS -DMODULE_NAME="statistics"
)

# ── Process statistic ──
apollo_component(
    NAME libprocess_statistic_component.so
    SRCS
        process/process_statistic_component.cc
        process/process_statistic_gflags.cc
    DEPS
        cyber
        common_util
        process_statistic_cc_proto
    COPTS -DMODULE_NAME="statistics"
)

# ── Resource statistic ──
set(_resource_deps
    cyber
    common_util
    resource_statistic_cc_proto
)
if(APOLLO_USE_GPU)
    list(APPEND _resource_deps nvidia_ml)
endif()

apollo_component(
    NAME libresource_statistic_component.so
    SRCS
        resource/resource_statistic_gflags.cc
        resource/resource_statistic_component.cc
        resource/cpu_resource_statistic.cc
        resource/gpu_resource_statistic.cc
        resource/disk_resource_statistic.cc
        resource/memory_resource_statistic.cc
        resource/util.cc
    DEPS ${_resource_deps}
    COPTS -DMODULE_NAME="statistics"
)
