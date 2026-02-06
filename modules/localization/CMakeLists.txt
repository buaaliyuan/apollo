# ============================================================================
# modules/localization/CMakeLists.txt
# ============================================================================

# ── Proto ──
apollo_proto_library(
    NAME rtk_config_cc_proto
    SRCS proto/rtk_config.proto
)

apollo_proto_library(
    NAME localization_config_cc_proto
    SRCS proto/localization_config.proto
)

apollo_proto_library(
    NAME measure_cc_proto
    SRCS proto/measure.proto
    DEPS localization_cc_proto gnss_raw_observation_cc_proto
)

apollo_proto_library(
    NAME sins_pva_cc_proto
    SRCS proto/sins_pva.proto
    DEPS geometry_cc_proto
)

apollo_proto_library(
    NAME gnss_pnt_result_cc_proto
    SRCS proto/gnss_pnt_result.proto
    DEPS header_cc_proto geometry_cc_proto
)

# ── localization_gflags ──
apollo_cc_library(
    NAME localization_gflags
    SRCS common/localization_gflags.cc
    HDRS common/localization_gflags.h
    DEPS gflags
)

# ── gnss_compensator ──
apollo_cc_library(
    NAME gnss_compensator
    SRCS common/gnss_compensator.cc
    HDRS common/gnss_compensator.h
    DEPS localization_gflags cyber
)

# ── MSF (Multi-Sensor Fusion) localization library ──
file(GLOB_RECURSE _msf_lib_srcs msf/common/*.cc msf/local_map/*.cc msf/local_pyramid_map/*.cc
     msf/local_tool/*.cc msf/local_integ/*.cc)
list(FILTER _msf_lib_srcs EXCLUDE REGEX ".*_test\\.cc$")
# Remove binary main files
list(FILTER _msf_lib_srcs EXCLUDE REGEX ".*lossless_map_creator\\.cc$")
list(FILTER _msf_lib_srcs EXCLUDE REGEX ".*lossless_map_to_lossy_map\\.cc$")
list(FILTER _msf_lib_srcs EXCLUDE REGEX ".*poses_interpolator\\.cc$")
list(FILTER _msf_lib_srcs EXCLUDE REGEX ".*offline_local_visualizer_main\\.cc$")
list(FILTER _msf_lib_srcs EXCLUDE REGEX ".*cyber_record_parser\\.cc$")
list(FILTER _msf_lib_srcs EXCLUDE REGEX ".*compare_poses\\.cc$")

apollo_cc_library(
    NAME apollo_localization_msf
    SRCS ${_msf_lib_srcs}
    DEPS
        cyber
        localization_gflags
        gnss_compensator
        adapter_gflags
        config_gflags
        common_math
        monitor_log
        status
        common_util
        util_tool
        vehicle_state_provider
        # Proto deps
        localization_cc_proto
        localization_config_cc_proto
        measure_cc_proto
        sins_pva_cc_proto
        gnss_pnt_result_cc_proto
        gnss_raw_observation_cc_proto
        gnss_best_pose_cc_proto
        sensor_imu_cc_proto
        heading_cc_proto
        pointcloud_cc_proto
        pose_cc_proto
        header_cc_proto
        geometry_cc_proto
        # Third party
        Boost::filesystem
        Boost::thread
        gflags
        glog::glog
        eigen
        yaml-cpp
        absl
        pcl
        localization_msf_lib
        ${OpenCV_LIBS}
    COPTS -DMODULE_NAME="localization"
)

# ── MSF component ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/msf/msf_localization_component.cc")
    apollo_component(
        NAME libmsf_localization_component.so
        SRCS
            msf/msf_localization.cc
            msf/msf_localization_component.cc
        HDRS
            msf/msf_localization.h
            msf/msf_localization_component.h
        DEPS
            apollo_localization_msf
            cyber
        COPTS -DMODULE_NAME="localization"
    )
endif()

# ── NDT localization ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/ndt/ndt_localization_component.cc")
    # NDT locator library
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/ndt/ndt_locator/lidar_locator_ndt.cc")
        apollo_cc_library(
            NAME ndt_lidar_locator
            SRCS ndt/ndt_locator/lidar_locator_ndt.cc
            HDRS ndt/ndt_locator/lidar_locator_ndt.h
                 ndt/ndt_locator/ndt_solver.h
            DEPS
                apollo_localization_msf
                cyber
                eigen
                Boost::filesystem
            COPTS -DMODULE_NAME="NDTlocalization"
        )
    endif()

    apollo_component(
        NAME libndt_localization_component.so
        SRCS
            ndt/localization_pose_buffer.cc
            ndt/ndt_localization.cc
            ndt/ndt_localization_component.cc
        HDRS
            ndt/localization_pose_buffer.h
            ndt/ndt_localization.h
            ndt/ndt_localization_component.h
        DEPS
            apollo_localization_msf
            apollo_transform
            ndt_lidar_locator
            cyber
            localization_gflags
            localization_cc_proto
            localization_config_cc_proto
            gflags
        COPTS -DMODULE_NAME="NDTlocalization"
    )
endif()

# ── RTK localization ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/rtk/rtk_localization_component.cc")
    apollo_component(
        NAME librtk_localization_component.so
        SRCS
            rtk/rtk_localization.cc
            rtk/rtk_localization_component.cc
        HDRS
            rtk/rtk_localization.h
            rtk/rtk_localization_component.h
        DEPS
            cyber
            localization_gflags
            gnss_compensator
            adapter_gflags
            monitor_log
            common_util
            apollo_transform
            localization_cc_proto
            rtk_config_cc_proto
            gps_cc_proto
            localization_imu_cc_proto
            localization_config_cc_proto
            gflags
        COPTS -DMODULE_NAME="localization"
    )
endif()

# ── MSF tool binaries ──
foreach(_tool lossless_map_creator lossless_map_to_lossy_map poses_interpolator)
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/msf/local_tool/map_creation/${_tool}.cc")
        apollo_cc_binary(
            NAME ${_tool}
            SRCS msf/local_tool/map_creation/${_tool}.cc
            DEPS apollo_localization_msf cyber gflags Boost::program_options
        )
    endif()
endforeach()

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/ndt/map_creation/ndt_map_creator.cc")
    apollo_cc_binary(
        NAME ndt_map_creator
        SRCS ndt/map_creation/ndt_map_creator.cc
        DEPS apollo_localization_msf cyber Boost::filesystem Boost::program_options absl eigen
    )
endif()
