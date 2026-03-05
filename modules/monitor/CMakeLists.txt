add_library(monitor SHARED
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
)

target_link_libraries(monitor
PUBLIC
        cyber
        modules_common
        Eigen3::Eigen
)


install(TARGETS monitor
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)