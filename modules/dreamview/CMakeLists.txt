# ============================================================================
# modules/dreamview/CMakeLists.txt
# ============================================================================

# ── Proto (dreamview/proto/) ──
apollo_proto_library(
    NAME dv_camera_update_cc_proto
    SRCS proto/camera_update.proto
    DEPS perception_obstacle_cc_proto
)

apollo_proto_library(
    NAME dv_point_cloud_cc_proto
    SRCS proto/point_cloud.proto
)

apollo_proto_library(
    NAME dv_preprocess_table_cc_proto
    SRCS proto/preprocess_table.proto
)

apollo_proto_library(
    NAME dv_data_collection_table_cc_proto
    SRCS proto/data_collection_table.proto
)

apollo_proto_library(
    NAME dv_plugin_config_cc_proto
    SRCS proto/plugin_config.proto
)

apollo_proto_library(
    NAME dv_plugin_msg_cc_proto
    SRCS proto/dv_plugin_msg.proto
    DEPS header_cc_proto
)

apollo_proto_library(
    NAME dv_scenario_cc_proto
    SRCS proto/scenario.proto
    DEPS simulation_scenario_cc_proto
)

apollo_proto_library(
    NAME dv_record_cc_proto
    SRCS proto/record.proto
)

# ── Proto (backend/common/sim_control_manager/proto/) ──
apollo_proto_library(
    NAME dynamic_model_conf_cc_proto
    SRCS backend/common/sim_control_manager/proto/dynamic_model_conf.proto
)

apollo_proto_library(
    NAME sim_control_internal_cc_proto
    SRCS backend/common/sim_control_manager/proto/sim_control_internal.proto
    DEPS header_cc_proto
)

# ── dreamview_common library ──
apollo_cc_library(
    NAME dreamview_common
    SRCS
        backend/common/dreamview_gflags.cc
        backend/common/util/hmi_util.cc
        backend/common/handlers/image_handler.cc
        backend/common/handlers/proto_handler.cc
        backend/common/handlers/websocket_handler.cc
        backend/common/map_service/map_service.cc
        backend/common/sim_control_manager/common/interpolation_2d.cc
        backend/common/sim_control_manager/common/sim_control_gflags.cc
        backend/common/sim_control_manager/common/sim_control_util.cc
        backend/common/sim_control_manager/core/dynamic_model_factory.cc
        backend/common/sim_control_manager/core/sim_control_base.cc
        backend/common/sim_control_manager/core/sim_control_with_model_base.cc
        backend/common/sim_control_manager/dynamic_model/perfect_control/sim_perfect_control.cc
        backend/common/sim_control_manager/sim_control_manager.cc
        backend/common/vehicle_manager/vehicle_manager.cc
        backend/common/fuel_monitor/data_collection_monitor.cc
        backend/common/fuel_monitor/fuel_monitor_gflags.cc
        backend/common/fuel_monitor/fuel_monitor_manager.cc
        backend/common/fuel_monitor/preprocess_monitor.cc
        backend/common/plugins/plugin_manager.cc
    HDRS
        backend/common/dreamview_gflags.h
        backend/common/util/hmi_util.h
        backend/common/handlers/image_handler.h
        backend/common/handlers/proto_handler.h
        backend/common/handlers/websocket_handler.h
        backend/common/map_service/map_service.h
        backend/common/sim_control_manager/common/interpolation_2d.h
        backend/common/sim_control_manager/common/sim_control_gflags.h
        backend/common/sim_control_manager/common/sim_control_util.h
        backend/common/sim_control_manager/core/dynamic_model_factory.h
        backend/common/sim_control_manager/core/sim_control_base.h
        backend/common/sim_control_manager/core/sim_control_with_model_base.h
        backend/common/sim_control_manager/dynamic_model/perfect_control/sim_perfect_control.h
        backend/common/sim_control_manager/sim_control_manager.h
        backend/common/vehicle_manager/vehicle_manager.h
        backend/common/fuel_monitor/data_collection_monitor.h
        backend/common/fuel_monitor/fuel_monitor.h
        backend/common/fuel_monitor/fuel_monitor_gflags.h
        backend/common/fuel_monitor/fuel_monitor_manager.h
        backend/common/fuel_monitor/preprocess_monitor.h
        backend/common/plugins/plugin_manager.h
    DEPS
        cyber
        gflags
        absl
        nlohmann_json
        opencv_imgcodecs
        civetweb
        adapter_gflags
        config_gflags
        vehicle_config_helper
        util_tool
        apollo_map
        # Proto deps
        hmi_config_cc_proto
        hmi_mode_cc_proto
        simulation_world_cc_proto
        sensor_image_cc_proto
        routing_cc_proto
        prediction_obstacle_cc_proto
        control_cmd_cc_proto
        planning_cc_proto
        chassis_cc_proto
        dynamic_model_conf_cc_proto
        sim_control_internal_cc_proto
        dv_data_collection_table_cc_proto
        dv_preprocess_table_cc_proto
        dv_plugin_msg_cc_proto
        dv_plugin_config_cc_proto
    COPTS -DMODULE_NAME="dreamview"
)

# ── vehicle_manager_main binary ──
apollo_cc_binary(
    NAME vehicle_manager_main
    SRCS backend/common/vehicle_manager/vehicle_manager_main.cc
    DEPS dreamview_common cyber gflags
)

# ── apollo_dreamview_backend library ──
apollo_cc_library(
    NAME apollo_dreamview_backend
    SRCS
        backend/dreamview.cc
        backend/hmi/hmi.cc
        backend/hmi/hmi_worker.cc
        backend/perception_camera_updater/perception_camera_updater.cc
        backend/point_cloud/point_cloud_updater.cc
        backend/simulation_world/simulation_world_service.cc
        backend/simulation_world/simulation_world_updater.cc
    HDRS
        backend/dreamview.h
        backend/hmi/hmi.h
        backend/hmi/hmi_worker.h
        backend/perception_camera_updater/perception_camera_updater.h
        backend/point_cloud/point_cloud_updater.h
        backend/simulation_world/simulation_world_service.h
        backend/simulation_world/simulation_world_updater.h
    DEPS
        cyber
        dreamview_common
        common_math
        monitor_log
        status
        kv_db
        common_util
        util_tool
        vehicle_config_helper
        config_gflags
        adapter_gflags
        apollo_map
        apollo_transform
        # Proto deps
        dag_conf_cc_proto
        transform_cc_proto
        pointcloud_cc_proto
        sensor_image_cc_proto
        navigation_cc_proto
        prediction_scenario_cc_proto
        planning_command_cc_proto
        drive_event_cc_proto
        geometry_cc_proto
        control_cmd_cc_proto
        gps_cc_proto
        localization_cc_proto
        perception_obstacle_cc_proto
        planning_cc_proto
        prediction_obstacle_cc_proto
        story_cc_proto
        simulation_scenario_cc_proto
        hmi_status_cc_proto
        system_status_cc_proto
        poi_cc_proto
        task_manager_cc_proto
        control_pad_msg_cc_proto
        planning_pad_msg_cc_proto
        routing_cc_proto
        lane_follow_command_cc_proto
        valet_parking_command_cc_proto
        action_command_cc_proto
        command_status_cc_proto
        audio_cc_proto
        audio_event_cc_proto
        chassis_cc_proto
        hmi_config_cc_proto
        hmi_mode_cc_proto
        simulation_world_cc_proto
        dv_camera_update_cc_proto
        dv_point_cloud_cc_proto
        dv_preprocess_table_cc_proto
        dv_record_cc_proto
        dv_scenario_cc_proto
        # Third-party
        Boost::filesystem
        Boost::regex
        Boost::thread
        civetweb
        gflags
        glog
        yaml-cpp
        nlohmann_json
        absl
        gtest_headers
        protobuf::libprotobuf
        eigen
        pcl
        opencv_imgcodecs
    COPTS -DMODULE_NAME="dreamview"
)

# ── dreamview binary ──
apollo_cc_binary(
    NAME dreamview
    SRCS main.cc
    DEPS cyber apollo_dreamview_backend
)
