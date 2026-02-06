# ============================================================================
# modules/monitor/CMakeLists.txt
# ============================================================================

# ── apollo_monitor library ──
apollo_cc_library(
    NAME apollo_monitor
    SRCS
        common/recurrent_runner.cc
        common/monitor_manager.cc
        hardware/gps_monitor.cc
        hardware/resource_monitor.cc
        hardware/esdcan_monitor.cc
        hardware/socket_can_monitor.cc
        software/process_monitor.cc
        software/module_monitor.cc
        software/camera_monitor.cc
        software/channel_monitor.cc
        software/localization_monitor.cc
        software/functional_safety_monitor.cc
        software/summary_monitor.cc
        software/recorder_monitor.cc
        software/latency_monitor.cc
    HDRS
        common/recurrent_runner.h
        common/monitor_manager.h
        hardware/gps_monitor.h
        hardware/resource_monitor.h
        hardware/esdcan_monitor.h
        hardware/socket_can_monitor.h
        software/process_monitor.h
        software/module_monitor.h
        software/camera_monitor.h
        software/channel_monitor.h
        software/localization_monitor.h
        software/functional_safety_monitor.h
        software/summary_monitor.h
        software/recorder_monitor.h
        software/latency_monitor.h
    DEPS
        cyber
        drive_event_cc_proto
        common_util
        chassis_cc_proto
        conti_radar_cc_proto
        control_cmd_cc_proto
        sensor_image_cc_proto
        pose_cc_proto
        chassis_detail_cc_proto
        system_status_cc_proto
        planning_cc_proto
        pointcloud_cc_proto
        localization_cc_proto
        hmi_mode_cc_proto
        navigation_cc_proto
        perception_obstacle_cc_proto
        adapter_gflags
        latency_record_cc_proto
        monitor_log
        hmi_config_cc_proto
        hmi_status_cc_proto
        gnss_best_pose_cc_proto
        prediction_obstacle_cc_proto
        util_tool
        smart_recorder_status_cc_proto
        apollo_drivers_canbus
        Boost::filesystem
        Boost::regex
        absl
        gflags
    COPTS -DMODULE_NAME="monitor"
)

# ── monitor_component ──
apollo_component(
    NAME libmonitor.so
    SRCS monitor.cc
    HDRS monitor.h
    DEPS
        apollo_monitor
        cyber
        util_tool
    COPTS -DMODULE_NAME="monitor"
)
