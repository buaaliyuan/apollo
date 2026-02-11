# ============================================================================
# modules/perception/tools/CMakeLists.txt
# Perception tools: common utilities, offline tools, exporter
# ============================================================================

# ── tools/common ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/common")
    file(GLOB _tools_common_srcs common/*.cc)
    list(FILTER _tools_common_srcs EXCLUDE REGEX ".*_test\\.cc$")
    file(GLOB _tools_common_hdrs common/*.h)

    if(_tools_common_srcs)
        apollo_cc_library(
            NAME apollo_perception_tools_common
            SRCS ${_tools_common_srcs}
            HDRS ${_tools_common_hdrs}
            DEPS
                cyber
                apollo_perception_common_algorithm
                apollo_perception_common_base
                apollo_perception_common_onboard
                ${OpenCV_LIBS}
            COPTS -DMODULE_NAME="perception"
        )
    endif()
endif()

# ── tools/offline ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/offline")
    # transform_server
    apollo_cc_library(
        NAME perception_transform_server
        SRCS offline/transform_server.cc
        HDRS offline/transform_server.h
        DEPS
            cyber
            apollo_perception_common_base
            apollo_perception_common_camera
            yaml-cpp
            eigen
        COPTS -DMODULE_NAME="perception"
    )

    # visualizer
    apollo_cc_library(
        NAME perception_visualizer
        SRCS offline/visualizer.cc
        HDRS
            offline/colormap.h
            offline/keycode.h
            offline/visualizer.h
        DEPS
            perception_transform_server
            perception_gflags
            apollo_perception_common_camera
            perception_motion_service_cc_proto
            ${OpenCV_LIBS}
        COPTS -DMODULE_NAME="perception"
    )
endif()

# ── tools/exporter ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/exporter")
    # msgexporterlib: msg_exporter.cc + msg_exporter.h
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/exporter/msg_exporter.cc")
        apollo_cc_library(
            NAME msgexporterlib
            SRCS exporter/msg_exporter.cc
            HDRS exporter/msg_exporter.h
            DEPS
                cyber
                apollo_perception_common_base
                apollo_perception_common_onboard
                apollo_perception_common_lidar
                pointcloud_cc_proto
                sensor_image_cc_proto
                absl
                ${OpenCV_LIBS}
                pcl
            COPTS -DMODULE_NAME="perception"
        )
    endif()

    # msg_exporter binary: msg_exporter_main.cc
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/exporter/msg_exporter_main.cc" AND TARGET msgexporterlib)
        apollo_cc_binary(
            NAME msg_exporter
            SRCS exporter/msg_exporter_main.cc
            DEPS
                msgexporterlib
                cyber
                pointcloud_cc_proto
                sensor_image_cc_proto
                absl
        )
    endif()
endif()

# ── tools/offline_camera_detection ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/offline_camera_detection")
    file(GLOB _ocd_srcs offline_camera_detection/*.cc)
    list(FILTER _ocd_srcs EXCLUDE REGEX ".*_test\\.cc$")
    if(_ocd_srcs)
        apollo_cc_binary(
            NAME offline_camera_detection
            SRCS ${_ocd_srcs}
            DEPS
                cyber
                apollo_perception_common_base
                apollo_perception_common_camera
                apollo_perception_common_inference
                apollo_perception_common_onboard
                perception_gflags
                Boost::filesystem
                apollo_perception_tools_common
                apollo_perception_common_lib
        )
    endif()
endif()
