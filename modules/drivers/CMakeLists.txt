# ============================================================================
# modules/drivers/CMakeLists.txt
# ============================================================================

add_subdirectory(canbus)

# ============================================================================
# PROTOS (define all driver protos first, before any libraries)
# ============================================================================

# ── microphone protos ──
apollo_proto_library(
    NAME microphone_config_cc_proto
    SRCS microphone/proto/microphone_config.proto
)
apollo_proto_library(
    NAME microphone_audio_cc_proto
    SRCS microphone/proto/audio.proto
    DEPS header_cc_proto microphone_config_cc_proto
)

# ── camera proto ──
apollo_proto_library(
    NAME drivers_camera_config_cc_proto
    SRCS camera/proto/config.proto
)

# ── gnss protos ──
apollo_proto_library(
    NAME drivers_gnss_config_cc_proto
    SRCS gnss/proto/config.proto
    DEPS header_cc_proto can_card_parameter_cc_proto
)
apollo_proto_library(
    NAME drivers_gnss_status_cc_proto
    SRCS gnss/proto/gnss_status.proto
    DEPS header_cc_proto
)

# ── lidar protos (leaf protos — no deps) ──
apollo_proto_library(
    NAME drivers_lidar_parameter_cc_proto
    SRCS lidar/proto/lidar_parameter.proto
)
apollo_proto_library(
    NAME drivers_lidar_common_config_base_cc_proto
    SRCS lidar/common/proto/lidar_config_base.proto
)
apollo_proto_library(
    NAME drivers_compensator_config_cc_proto
    SRCS lidar/compensator/proto/compensator_config.proto
)
apollo_proto_library(
    NAME drivers_fusion_config_cc_proto
    SRCS lidar/fusion/proto/fusion_config.proto
)
# ── lidar protos (depend on header_cc_proto) ──
apollo_proto_library(
    NAME drivers_velodyne_cc_proto
    SRCS lidar/proto/velodyne.proto
    DEPS header_cc_proto
)
apollo_proto_library(
    NAME drivers_hesai_cc_proto
    SRCS lidar/proto/hesai.proto
    DEPS header_cc_proto
)
apollo_proto_library(
    NAME drivers_hslidar_hesai_cc_proto
    SRCS lidar/hslidar/proto/hesai.proto
    DEPS header_cc_proto
)
apollo_proto_library(
    NAME drivers_lslidar_cc_proto
    SRCS lidar/lslidar/proto/lslidar.proto
    DEPS header_cc_proto
)
apollo_proto_library(
    NAME drivers_rslidar_cc_proto
    SRCS lidar/rslidar/proto/rslidar.proto
    DEPS header_cc_proto
)
apollo_proto_library(
    NAME drivers_vanjeelidar_cc_proto
    SRCS lidar/vanjeelidar/proto/vanjeelidar.proto
    DEPS header_cc_proto
)
# ── lidar protos (depend on other driver protos) ──
apollo_proto_library(
    NAME drivers_velodyne_config_cc_proto
    SRCS lidar/proto/velodyne_config.proto
    DEPS drivers_velodyne_cc_proto
)
apollo_proto_library(
    NAME drivers_hesai_config_cc_proto
    SRCS lidar/proto/hesai_config.proto
    DEPS drivers_hesai_cc_proto
)
apollo_proto_library(
    NAME drivers_hslidar_hesai_config_cc_proto
    SRCS lidar/hslidar/proto/hesai_config.proto
    DEPS drivers_hslidar_hesai_cc_proto drivers_lidar_common_config_base_cc_proto
)
apollo_proto_library(
    NAME drivers_livox_cc_proto
    SRCS lidar/livox/proto/livox.proto
    DEPS drivers_lidar_common_config_base_cc_proto
)
apollo_proto_library(
    NAME drivers_lslidar_config_cc_proto
    SRCS lidar/lslidar/proto/config.proto
    DEPS drivers_lslidar_cc_proto drivers_lidar_common_config_base_cc_proto
)
apollo_proto_library(
    NAME drivers_rslidar_config_cc_proto
    SRCS lidar/rslidar/proto/rslidar_config.proto
    DEPS drivers_lidar_common_config_base_cc_proto
)
apollo_proto_library(
    NAME drivers_vanjeelidar_config_cc_proto
    SRCS lidar/vanjeelidar/proto/vanjeelidar_config.proto
    DEPS drivers_lidar_common_config_base_cc_proto
)
# ── lidar protos (depend on config protos) ──
apollo_proto_library(
    NAME drivers_lidar_config_cc_proto
    SRCS lidar/proto/config.proto
    DEPS drivers_hesai_config_cc_proto drivers_velodyne_config_cc_proto drivers_lidar_parameter_cc_proto
)

# ── lidar_fusion_and_compensator proto ──
apollo_proto_library(
    NAME drivers_lidar_fusion_compensator_config_cc_proto
    SRCS lidar_fusion_and_compensator/proto/config.proto
)

# ── radar protos ──
apollo_proto_library(
    NAME drivers_conti_radar_conf_cc_proto
    SRCS radar/conti_radar/proto/conti_radar_conf.proto
    DEPS conti_radar_cc_proto can_card_parameter_cc_proto
)
apollo_proto_library(
    NAME drivers_nano_radar_conf_cc_proto
    SRCS radar/nano_radar/proto/nano_radar_conf.proto
    DEPS nano_radar_cc_proto can_card_parameter_cc_proto
)
apollo_proto_library(
    NAME drivers_oculii_radar_conf_cc_proto
    SRCS radar/oculii_radar/proto/oculii_radar_conf.proto
)
apollo_proto_library(
    NAME drivers_racobit_radar_conf_cc_proto
    SRCS radar/racobit_radar/proto/racobit_radar_conf.proto
    DEPS racobit_radar_cc_proto can_card_parameter_cc_proto
)
apollo_proto_library(
    NAME drivers_ultrasonic_radar_conf_cc_proto
    SRCS radar/ultrasonic_radar/proto/ultrasonic_radar_conf.proto
    DEPS can_card_parameter_cc_proto
)

# ── smartereye proto ──
apollo_proto_library(
    NAME drivers_smartereye_config_cc_proto
    SRCS smartereye/proto/config.proto
)

# ── video proto ──
apollo_proto_library(
    NAME drivers_video_h265cfg_cc_proto
    SRCS video/proto/video_h265cfg.proto
)

# ── image_decompress proto ──
apollo_proto_library(
    NAME drivers_image_decompress_config_cc_proto
    SRCS tools/image_decompress/proto/config.proto
)

# ============================================================================
# CAMERA (components)
# ============================================================================
apollo_cc_library(
    NAME apollo_camera_util
    SRCS
        camera/usb_cam.cc
        camera/util.cc
    DEPS
        cyber
        drivers_camera_config_cc_proto
        ffmpeg
        adv_plat
    COPTS -DMODULE_NAME="camera" -fopenmp -mavx2
)

apollo_component(
    NAME libcamera_component.so
    SRCS camera/camera_component.cc
    DEPS
        apollo_camera_util
        cyber
        error_code_cc_proto
        header_cc_proto
        sensor_image_cc_proto
        ffmpeg
    COPTS -DMODULE_NAME="camera"
)

apollo_component(
    NAME libcamera_compress_component.so
    SRCS camera/compress_component.cc
    DEPS
        cyber
        error_code_cc_proto
        header_cc_proto
        drivers_camera_config_cc_proto
        sensor_image_cc_proto
        opencv_core opencv_highgui opencv_imgcodecs opencv_imgproc
    COPTS -DMODULE_NAME="camera"
)

# ============================================================================
# GNSS
# ============================================================================
apollo_cc_library(
    NAME apollo_drivers_gnss
    SRCS
        gnss/parser/data_parser.cc
        gnss/parser/novatel_parser.cc
        gnss/parser/rtcm3_parser.cc
        gnss/parser/rtcm_parser.cc
        gnss/parser/asensing_parser/asensing_base_parser.cc
        gnss/parser/asensing_parser/asensing_binary_parser.cc
        gnss/parser/asensing_parser/asensing_can_parser.cc
        gnss/parser/asensing_parser/decode_0A.cc
        gnss/parser/asensing_parser/decode_0B.cc
        gnss/parser/asensing_parser/protocol_asensing.cc
        gnss/parser/broadgnss_parser/broadgnss_base_parser.cc
        gnss/parser/broadgnss_parser/broadgnss_text_parser.cc
        gnss/parser/huace_parser/huace_base_parser.cc
        gnss/parser/huace_parser/huace_text_parser.cc
        gnss/stream/can_stream.cc
        gnss/stream/ntrip_stream.cc
        gnss/stream/raw_stream.cc
        gnss/stream/serial_stream.cc
        gnss/stream/tcp_stream.cc
        gnss/stream/udp_stream.cc
    DEPS
        cyber
        common_util
        monitor_log
        adapter_gflags
        apollo_drivers_canbus
        apollo_transform
        drivers_gnss_config_cc_proto
        drivers_gnss_status_cc_proto
        error_code_cc_proto
        header_cc_proto
        geometry_cc_proto
        pnc_point_cc_proto
        vehicle_signal_cc_proto
        drive_state_cc_proto
        chassis_cc_proto
        vehicle_config_cc_proto
        gps_cc_proto
        sensor_imu_cc_proto
        gnss_best_pose_cc_proto
        gnss_cc_proto
        gnss_raw_observation_cc_proto
        heading_cc_proto
        ins_cc_proto
        localization_imu_cc_proto
        rtklib
        proj_lib
        eigen
        absl
    COPTS -DMODULE_NAME="gnss"
)

apollo_component(
    NAME libgnss_component.so
    SRCS gnss/gnss_component.cc
    DEPS apollo_drivers_gnss
    COPTS -DMODULE_NAME="gnss"
)

apollo_cc_binary(
    NAME parser_cli
    SRCS gnss/test/parser_cli.cc
    DEPS
        cyber
        drivers_gnss_status_cc_proto
        apollo_drivers_gnss
        gflags
)

# ============================================================================
# LIDAR – common/driver_factory
# ============================================================================
apollo_cc_library(
    NAME lidar_common
    SRCS lidar/common/util.cpp
    DEPS
        cyber
        drivers_lidar_common_config_base_cc_proto
        pointcloud_cc_proto
        Boost::boost
    COPTS -DMODULE_NAME="lidar"
)

# ── Velodyne driver lib ──
apollo_cc_library(
    NAME velodyne_driver_lib
    SRCS
        lidar/velodyne/driver/driver.cc
        lidar/velodyne/driver/driver64.cc
        lidar/velodyne/driver/input.cc
        lidar/velodyne/driver/socket_input.cc
    DEPS
        cyber
        common_util
        drivers_lidar_config_cc_proto
        drivers_velodyne_config_cc_proto
    COPTS -DMODULE_NAME="velodyne"
)

apollo_cc_library(
    NAME lidar_driver_factory
    SRCS lidar/common/driver_factory/lidar_driver_factory.cc
    DEPS
        cyber
        common_util
        drivers_lidar_config_cc_proto
        drivers_lidar_parameter_cc_proto
        velodyne_driver_lib
    COPTS -DMODULE_NAME="lidar"
)

# ── lidar_driver_component ──
apollo_component(
    NAME liblidar_driver_component.so
    SRCS lidar/lidar_driver_component.cc
    DEPS
        cyber
        lidar_driver_factory
        drivers_lidar_config_cc_proto
    COPTS -DMODULE_NAME="lidar"
)

# ── Velodyne sub-components ──
apollo_component(
    NAME libvelodyne_driver_component.so
    SRCS lidar/velodyne/driver/velodyne_driver_component.cc
    DEPS velodyne_driver_lib
    COPTS -DMODULE_NAME="velodyne"
)

apollo_component(
    NAME libvelodyne_convert_component.so
    SRCS
        lidar/velodyne/parser/velodyne_convert_component.cc
        lidar/velodyne/parser/calibration.cc
        lidar/velodyne/parser/convert.cc
        lidar/velodyne/parser/online_calibration.cc
        lidar/velodyne/parser/util.cc
        lidar/velodyne/parser/velodyne128_parser.cc
        lidar/velodyne/parser/velodyne16_parser.cc
        lidar/velodyne/parser/velodyne32_parser.cc
        lidar/velodyne/parser/velodyne64_parser.cc
        lidar/velodyne/parser/velodyne_parser.cc
    DEPS
        cyber
        drivers_velodyne_config_cc_proto
        pointcloud_cc_proto
        Boost::boost
        yaml-cpp
        eigen
    COPTS -DMODULE_NAME="velodyne"
)

apollo_component(
    NAME libvelodyne_compensator_component.so
    SRCS
        lidar/velodyne/compensator/compensator_component.cc
        lidar/velodyne/compensator/compensator.cc
    DEPS
        cyber
        eigen
        common_util
        drivers_velodyne_cc_proto
        drivers_velodyne_config_cc_proto
        pointcloud_cc_proto
        apollo_transform
    COPTS -DMODULE_NAME="velodyne"
)

apollo_component(
    NAME libvelodyne_fusion_component.so
    SRCS lidar/velodyne/fusion/pri_sec_fusion_component.cc
    DEPS
        cyber
        drivers_velodyne_config_cc_proto
        pointcloud_cc_proto
        apollo_transform
        eigen
    COPTS -DMODULE_NAME="velodyne"
)

# ── Compensator (generic) ──
apollo_component(
    NAME libcompensator_component.so
    SRCS
        lidar/compensator/compensator_component.cc
        lidar/compensator/compensator.cc
    DEPS
        cyber
        eigen
        common_util
        drivers_compensator_config_cc_proto
        pointcloud_cc_proto
        apollo_transform
    COPTS -DMODULE_NAME="compensator"
)

# ── Fusion (generic) ──
apollo_component(
    NAME libfusion_component.so
    SRCS lidar/fusion/pri_sec_fusion_component.cc
    DEPS
        cyber
        drivers_fusion_config_cc_proto
        pointcloud_cc_proto
        apollo_transform
        eigen
    COPTS -DMODULE_NAME="fusion"
)

# ── Hesai (hslidar) ──
apollo_component(
    NAME libhesai_driver_component_2.so
    SRCS lidar/hslidar/driver/hesai_component.cc
    DEPS
        cyber
        lidar_common
        drivers_hslidar_hesai_cc_proto
        drivers_hslidar_hesai_config_cc_proto
        pointcloud_cc_proto
    COPTS -DMODULE_NAME="hesai" -fopenmp
    LINKOPTS -lgomp -lssl -lpthread -lm -lhesai2-driver
)

# ── LSLidar ──
apollo_cc_library(
    NAME lslidar_driver_lib
    SRCS
        lidar/lslidar/driver/driver.cc
        lidar/lslidar/driver/input.cc
    DEPS
        cyber
        common_util
        drivers_lslidar_config_cc_proto
    COPTS -DMODULE_NAME="lslidar"
)

apollo_cc_library(
    NAME lslidar_convert_lib
    SRCS
        lidar/lslidar/parser/calibration.cc
        lidar/lslidar/parser/convert.cc
        lidar/lslidar/parser/lslidar16_parser.cc
        lidar/lslidar/parser/lslidar32_parser.cc
        lidar/lslidar/parser/lslidarCH120_parser.cc
        lidar/lslidar/parser/lslidarCH128_parser.cc
        lidar/lslidar/parser/lslidarCH128X1_parser.cc
        lidar/lslidar/parser/lslidarCH16_parser.cc
        lidar/lslidar/parser/lslidarCH32_parser.cc
        lidar/lslidar/parser/lslidarCH64_parser.cc
        lidar/lslidar/parser/lslidarCH64w_parser.cc
        lidar/lslidar/parser/lslidarCXV4_parser.cc
        lidar/lslidar/parser/lslidarLS128S2_parser.cc
        lidar/lslidar/parser/lslidar_parser.cc
    DEPS
        cyber
        pointcloud_cc_proto
        drivers_lslidar_config_cc_proto
        drivers_lslidar_cc_proto
        yaml-cpp
    COPTS -DMODULE_NAME="lslidar"
)

# Note: lslidar component source is .cpp
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lidar/lslidar/component/lslidar_component.cpp")
    apollo_component(
        NAME liblslidar_component.so
        SRCS lidar/lslidar/component/lslidar_component.cpp
        DEPS
            lslidar_convert_lib
            lslidar_driver_lib
            lidar_common
            cyber
        COPTS -DMODULE_NAME="lslidar"
        LINKOPTS -lpcap
    )
endif()

# ── RSLidar ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lidar/rslidar/driver/rslidar_component.cpp")
    apollo_component(
        NAME librslidar_component.so
        SRCS lidar/rslidar/driver/rslidar_component.cpp
        DEPS
            pointcloud_cc_proto
            drivers_rslidar_config_cc_proto
            drivers_rslidar_cc_proto
            lidar_common
        COPTS -DMODULE_NAME="rslidar"
        LINKOPTS -lpcap
    )
endif()

# ── Livox ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lidar/livox/component/livox_component.cpp")
    apollo_component(
        NAME liblivox_component.so
        SRCS
            lidar/livox/component/livox_component.cpp
            lidar/livox/component/livox_dispatcher.cpp
            lidar/livox/driver/livox_util.cpp
        DEPS
            drivers_livox_cc_proto
            lidar_common
        COPTS -DMODULE_NAME="livox"
        LINKOPTS -llivox_lidar_sdk_shared
    )
endif()

# ── VanjeeLidar ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lidar/vanjeelidar/src/vanjeelidar_component.cpp")
    apollo_component(
        NAME libvanjeelidar_component.so
        SRCS lidar/vanjeelidar/src/vanjeelidar_component.cpp
        DEPS
            pointcloud_cc_proto
            drivers_vanjeelidar_config_cc_proto
            drivers_vanjeelidar_cc_proto
            lidar_common
        COPTS -DMODULE_NAME="vanjeelidar"
    )
endif()

# ============================================================================
# LIDAR FUSION AND COMPENSATOR
# ============================================================================
apollo_component(
    NAME liblidar_fusion_and_compensator_component.so
    SRCS lidar_fusion_and_compensator/fusion_and_compensator_component.cc
    DEPS
        cyber
        drivers_lidar_fusion_compensator_config_cc_proto
        pointcloud_cc_proto
        apollo_transform
        eigen
    COPTS -DMODULE_NAME="fusion_and_compensator"
)

# ============================================================================
# RADAR – Conti Radar
# ============================================================================
file(GLOB _conti_proto_srcs radar/conti_radar/protocol/*.cc)
apollo_cc_library(
    NAME conti_radar_protocol
    SRCS ${_conti_proto_srcs}
    DEPS
        header_cc_proto
        apollo_drivers_canbus
        can_card_parameter_cc_proto
        conti_radar_cc_proto
        drivers_conti_radar_conf_cc_proto
    COPTS -DMODULE_NAME="conti_radar"
)

apollo_cc_library(
    NAME conti_radar_message_manager
    SRCS radar/conti_radar/conti_radar_message_manager.cc
    DEPS
        common_util
        apollo_drivers_canbus
        conti_radar_protocol
    COPTS -DMODULE_NAME="conti_radar"
)

apollo_component(
    NAME libconti_radar.so
    SRCS radar/conti_radar/conti_radar_canbus_component.cc
    DEPS
        conti_radar_message_manager
        cyber
        common_util
        apollo_drivers_canbus
        sensor_canbus_conf_cc_proto
        conti_radar_protocol
        localization_cc_proto
        pose_cc_proto
        eigen
    COPTS -DMODULE_NAME="conti_radar"
)

# ── Nano Radar ──
file(GLOB _nano_proto_srcs radar/nano_radar/protocol/*.cc)
apollo_cc_library(
    NAME nano_radar_protocol
    SRCS ${_nano_proto_srcs}
    DEPS
        header_cc_proto
        apollo_drivers_canbus
        can_card_parameter_cc_proto
        nano_radar_cc_proto
        drivers_nano_radar_conf_cc_proto
    COPTS -DMODULE_NAME="nano_radar"
)

apollo_cc_library(
    NAME nano_radar_message_manager
    SRCS radar/nano_radar/nano_radar_message_manager.cc
    DEPS
        apollo_drivers_canbus
        nano_radar_protocol
    COPTS -DMODULE_NAME="nano_radar"
)

apollo_component(
    NAME libnano_radar.so
    SRCS radar/nano_radar/nano_radar_canbus_component.cc
    DEPS
        nano_radar_message_manager
        cyber
        common_util
        apollo_drivers_canbus
        sensor_canbus_conf_cc_proto
        nano_radar_protocol
        eigen
    COPTS -DMODULE_NAME="nano_radar"
)

# ── Oculii Radar ──
apollo_cc_library(
    NAME oculii_radar_parser
    SRCS radar/oculii_radar/parser/oculii_radar_udp_parser.cc
    DEPS
        cyber
        oculii_radar_cc_proto
        eigen
    COPTS -DMODULE_NAME="oculii_radar"
)

apollo_component(
    NAME liboculii_radar_component.so
    SRCS radar/oculii_radar/oculii_radar_component.cc
    DEPS
        oculii_radar_parser
        drivers_oculii_radar_conf_cc_proto
        common_util
    COPTS -DMODULE_NAME="oculii_radar"
)

# ── Racobit Radar ──
file(GLOB _racobit_proto_srcs radar/racobit_radar/protocol/*.cc)
apollo_cc_library(
    NAME racobit_radar_protocol
    SRCS ${_racobit_proto_srcs}
    DEPS
        header_cc_proto
        apollo_drivers_canbus
        can_card_parameter_cc_proto
        racobit_radar_cc_proto
        drivers_racobit_radar_conf_cc_proto
    COPTS -DMODULE_NAME="racobit_radar"
)

apollo_cc_library(
    NAME racobit_radar_message_manager
    SRCS radar/racobit_radar/racobit_radar_message_manager.cc
    DEPS
        common_util
        apollo_drivers_canbus
        racobit_radar_cc_proto
        racobit_radar_protocol
    COPTS -DMODULE_NAME="racobit_radar"
)

apollo_component(
    NAME libracobit_radar_canbus_component.so
    SRCS radar/racobit_radar/racobit_radar_canbus_component.cc
    DEPS
        racobit_radar_message_manager
        cyber
        common_util
        apollo_drivers_canbus
        sensor_canbus_conf_cc_proto
        racobit_radar_protocol
    COPTS -DMODULE_NAME="racobit_radar"
)

# ── Ultrasonic Radar ──
apollo_cc_library(
    NAME ultrasonic_radar_message_manager
    SRCS radar/ultrasonic_radar/ultrasonic_radar_message_manager.cc
    DEPS
        header_cc_proto
        common_util
        apollo_drivers_canbus
        ultrasonic_radar_cc_proto
    COPTS -DMODULE_NAME="ultrasonic_radar"
)

apollo_cc_library(
    NAME ultrasonic_radar_canbus_lib
    SRCS radar/ultrasonic_radar/ultrasonic_radar_canbus.cc
    DEPS
        ultrasonic_radar_message_manager
        common_util
        apollo_drivers_canbus
        sensor_canbus_conf_cc_proto
        drivers_ultrasonic_radar_conf_cc_proto
    COPTS -DMODULE_NAME="ultrasonic_radar"
)

apollo_component(
    NAME libultrasonic_radar_canbus_component.so
    SRCS radar/ultrasonic_radar/ultrasonic_radar_canbus_component.cc
    DEPS
        ultrasonic_radar_canbus_lib
        ultrasonic_radar_cc_proto
    COPTS -DMODULE_NAME="ultrasonic_radar"
)

# ============================================================================
# MICROPHONE (full component)
# ============================================================================
apollo_component(
    NAME libmicrophone_component.so
    SRCS
        microphone/microphone_component.cc
        microphone/respeaker.cc
    DEPS
        cyber
        common_util
        microphone_audio_cc_proto
        microphone_config_cc_proto
        portaudio
    COPTS -DMODULE_NAME="microphone"
)

# ============================================================================
# SMARTEREYE (optional – requires smartereye SDK)
# ============================================================================
# Smartereye camera SDK is not commonly available; skip if headers not found
# Uncomment if smartereye SDK is installed:
# apollo_component(
#     NAME libsmartereye_component.so
#     SRCS
#         smartereye/smartereye_component.cc
#         smartereye/compress_component.cc
#         smartereye/smartereye_device.cc
#         smartereye/smartereye_handler.cc
#     DEPS cyber apollo_common drivers_smartereye_config_cc_proto
#          sensor_image_cc_proto smartereye_cc_proto opencv_highgui
#     COPTS -DMODULE_NAME="camera"
# )

# ============================================================================
# VIDEO
# ============================================================================
apollo_cc_library(
    NAME apollo_video_driver
    SRCS video/driver.cc
    DEPS
        cyber
        sensor_image_cc_proto
        drivers_video_h265cfg_cc_proto
    COPTS -DMODULE_NAME="video"
)

apollo_cc_library(
    NAME apollo_video_socket
    SRCS video/socket_input.cc
    DEPS
        cyber
        error_code_cc_proto
        header_cc_proto
        common_util
        sensor_image_cc_proto
    COPTS -DMODULE_NAME="video"
)

apollo_component(
    NAME libvideo_driver_component.so
    SRCS video/video_driver_component.cc
    DEPS
        cyber
        common_util
        apollo_video_driver
        apollo_video_socket
    COPTS -DMODULE_NAME="video"
)

# ============================================================================
# IMAGE DECOMPRESS (tools)
# ============================================================================
apollo_component(
    NAME libimage_decompress.so
    SRCS tools/image_decompress/image_decompress.cc
    DEPS
        cyber
        error_code_cc_proto
        header_cc_proto
        sensor_image_cc_proto
        drivers_image_decompress_config_cc_proto
        opencv_imgcodecs
    COPTS -DMODULE_NAME="image_decompress"
)
