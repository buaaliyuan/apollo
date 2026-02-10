# ============================================================================
# modules/dreamview_plus/CMakeLists.txt
# ============================================================================

# ── Proto (dreamview_plus/proto/) ──
apollo_proto_library(
    NAME dreamview_plus_data_handler_cc_proto
    SRCS proto/data_handler.proto
)

apollo_proto_library(
    NAME dreamview_plus_obstacle_cc_proto
    SRCS proto/obstacle.proto
    DEPS simulation_world_cc_proto
)

# ── apollo_dreamview_plus_backend library ──
apollo_cc_library(
    NAME apollo_dreamview_plus_backend
    SRCS
        backend/dreamview.cc
        backend/hmi/hmi.cc
        backend/hmi/hmi_worker.cc
        backend/perception_camera_updater/perception_camera_updater.cc
        backend/point_cloud/point_cloud_updater.cc
        backend/simulation_world/simulation_world_service.cc
        backend/simulation_world/simulation_world_updater.cc
        backend/map/map_updater.cc
        backend/obstacle_updater/obstacle_updater.cc
        backend/channels_updater/channels_updater.cc
        backend/socket_manager/socket_manager.cc
        backend/record_player/record_player_factory.cc
        backend/updater/updater_manager.cc
        backend/updater/updater_with_channels_base.cc
        backend/updater/updater_base.cc
        backend/dv_plugin/dv_plugin_base.cc
        backend/dv_plugin/dv_plugin_manager.cc
    HDRS
        backend/dreamview.h
        backend/hmi/hmi.h
        backend/hmi/hmi_worker.h
        backend/perception_camera_updater/perception_camera_updater.h
        backend/point_cloud/point_cloud_updater.h
        backend/simulation_world/simulation_world_service.h
        backend/simulation_world/simulation_world_updater.h
        backend/map/map_updater.h
        backend/obstacle_updater/obstacle_updater.h
        backend/channels_updater/channels_updater.h
        backend/socket_manager/socket_manager.h
        backend/record_player/record_player_factory.h
        backend/updater/updater_manager.h
        backend/updater/updater_with_channels_base.h
        backend/updater/updater_base.h
        backend/dv_plugin/dv_plugin_base.h
        backend/dv_plugin/dv_plugin_manager.h
    DEPS
        cyber
        # Reuse dreamview common library
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
        # Proto deps (same as dreamview + extras)
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
        # dreamview_plus-specific protos
        dreamview_plus_data_handler_cc_proto
        dreamview_plus_obstacle_cc_proto
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
        cyber_recorder_lib
    COPTS -DMODULE_NAME="dreamview_plus"
)

# ── dreamview_plus binary ──
apollo_cc_binary(
    NAME dreamview_plus
    SRCS main.cc
    DEPS cyber apollo_dreamview_plus_backend
    LINKOPTS -ltcmalloc -lprofiler
)

# ── Frontend build (optional, controlled by APOLLO_BUILD_FRONTEND option) ──
if(APOLLO_BUILD_FRONTEND)
    message(STATUS "Building dreamview_plus frontend...")
    add_custom_target(dreamview_plus_frontend ALL
        COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/frontend && yarn web:build
        COMMENT "Building dreamview_plus frontend with yarn"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/frontend
    )
    add_dependencies(dreamview_plus dreamview_plus_frontend)
else()
    message(STATUS "Skipping dreamview_plus frontend build (use -DAPOLLO_BUILD_FRONTEND=ON to enable)")
endif()

# ── Install frontend dist files ──
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/frontend/dist)
    install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/frontend/dist/
        DESTINATION modules/dreamview_plus/frontend/dist
        FILES_MATCHING
            PATTERN "*"
    )
endif()
