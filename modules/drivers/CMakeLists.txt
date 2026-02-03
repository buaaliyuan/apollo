set(DRIVERS_COMMON_LIBS
	cyberrt
	common_msg
	common
	absl::strings
	gflags
)

# camera
file(GLOB_RECURSE CAMERA_SRCS "camera/*.cc" "camera/*.h" "camera/**/proto/*.cc" "camera/**/proto/*.h")
list(FILTER CAMERA_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(camera_component SHARED ${CAMERA_SRCS})
target_include_directories(camera_component PUBLIC ${OpenCV_INCLUDE_DIRS})
target_compile_options(camera_component PRIVATE -mavx2)
target_link_libraries(camera_component PUBLIC ${DRIVERS_COMMON_LIBS} ${OpenCV_LIBS} adv_bcan::adv_plat)
set_target_properties(camera_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# canbus
file(GLOB_RECURSE CANBUS_SRCS "canbus/*.cc" "canbus/*.h" "canbus/**/proto/*.cc" "canbus/**/proto/*.h")
list(FILTER CANBUS_SRCS EXCLUDE REGEX ".*_test.cc$|.*/esd_can_client\\.cc$|.*/esd_can_client\\.h$") #esd_can排除，没有头文件
add_library(lidar_driver_component SHARED ${CANBUS_SRCS})
target_link_libraries(lidar_driver_component PUBLIC ${DRIVERS_COMMON_LIBS})
set_target_properties(lidar_driver_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# gnss
file(GLOB_RECURSE GNSS_SRCS "gnss/*.cc" "gnss/*.h" "gnss/**/proto/*.cc" "gnss/**/proto/*.h")
list(FILTER GNSS_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(apollo_drivers_gnss SHARED ${GNSS_SRCS})
target_link_libraries(apollo_drivers_gnss PUBLIC ${DRIVERS_COMMON_LIBS})
set_target_properties(apollo_drivers_gnss PROPERTIES POSITION_INDEPENDENT_CODE ON)

# lidar common
file(GLOB_RECURSE LIDAR_COMMON_SRCS "lidar/common/*.cc" "lidar/common/*.h" "lidar/common/**/proto/*.cc" "lidar/common/**/proto/*.h")
list(FILTER LIDAR_COMMON_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(lidar_common SHARED ${LIDAR_COMMON_SRCS})
target_link_libraries(lidar_common PUBLIC ${DRIVERS_COMMON_LIBS})
set_target_properties(lidar_common PROPERTIES POSITION_INDEPENDENT_CODE ON)

# lidar driver factory
file(GLOB_RECURSE LIDAR_FACTORY_SRCS "lidar/common/driver_factory/*.cc" "lidar/common/driver_factory/*.h" "lidar/proto/*.cc" "lidar/proto/*.h")
list(FILTER LIDAR_FACTORY_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(lidar_driver_factory SHARED ${LIDAR_FACTORY_SRCS})
target_link_libraries(lidar_driver_factory PUBLIC ${DRIVERS_COMMON_LIBS})
set_target_properties(lidar_driver_factory PROPERTIES POSITION_INDEPENDENT_CODE ON)

# lidar base (header-only)
add_library(apollo_lidar_driver_base INTERFACE)

# lidar driver component
file(GLOB LIDAR_DRIVER_COMPONENT_SRCS "lidar/lidar_driver_component.cc" "lidar/lidar_driver_component.h")
add_library(liblidar_driver_component SHARED ${LIDAR_DRIVER_COMPONENT_SRCS})
target_link_libraries(liblidar_driver_component PUBLIC ${DRIVERS_COMMON_LIBS} lidar_driver_factory)
set_target_properties(liblidar_driver_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# velodyne (single target)
file(GLOB_RECURSE VELODYNE_SRCS "lidar/velodyne/*.cc" "lidar/velodyne/*.h" "lidar/velodyne/**/*.cc" "lidar/velodyne/**/*.h" "lidar/velodyne/proto/*.cc" "lidar/velodyne/proto/*.h")
list(FILTER VELODYNE_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(libvelodyne_driver_component SHARED ${VELODYNE_SRCS})
target_link_libraries(libvelodyne_driver_component PUBLIC ${DRIVERS_COMMON_LIBS} apollo_lidar_driver_base lidar_common)
set_target_properties(libvelodyne_driver_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# livox (single target)
file(GLOB_RECURSE LIVOX_SRCS "lidar/livox/*.cc" "lidar/livox/*.h" "lidar/livox/*.cpp" "lidar/livox/**/*.h" "lidar/livox/proto/*.cc" "lidar/livox/proto/*.h")
list(FILTER LIVOX_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(liblivox_component SHARED ${LIVOX_SRCS})
target_link_libraries(liblivox_component PUBLIC ${DRIVERS_COMMON_LIBS} lidar_common)
set_target_properties(liblivox_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# lslidar (single target)
file(GLOB_RECURSE LSLIDAR_SRCS "lidar/lslidar/*.cc" "lidar/lslidar/*.h" "lidar/lslidar/**/*.cc" "lidar/lslidar/**/*.h" "lidar/lslidar/proto/*.cc" "lidar/lslidar/proto/*.h")
list(FILTER LSLIDAR_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(liblslidar_component SHARED ${LSLIDAR_SRCS})
target_link_libraries(liblslidar_component PUBLIC ${DRIVERS_COMMON_LIBS} lidar_common)
set_target_properties(liblslidar_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# hslidar (hesai) (single target)
file(GLOB_RECURSE HSLIDAR_SRCS "lidar/hslidar/*.cc" "lidar/hslidar/*.h" "lidar/hslidar/**/*.cc" "lidar/hslidar/**/*.h" "lidar/hslidar/proto/*.cc" "lidar/hslidar/proto/*.h")
list(FILTER HSLIDAR_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(libhesai_driver_component_2 SHARED ${HSLIDAR_SRCS})
target_link_libraries(libhesai_driver_component_2 PUBLIC ${DRIVERS_COMMON_LIBS} lidar_common)
set_target_properties(libhesai_driver_component_2 PROPERTIES POSITION_INDEPENDENT_CODE ON)

# rslidar (single target)
file(GLOB_RECURSE RSLIDAR_SRCS "lidar/rslidar/*.cc" "lidar/rslidar/*.h" "lidar/rslidar/**/*.cc" "lidar/rslidar/**/*.h" "lidar/rslidar/proto/*.cc" "lidar/rslidar/proto/*.h")
list(FILTER RSLIDAR_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(librslidar_component SHARED ${RSLIDAR_SRCS})
target_link_libraries(librslidar_component PUBLIC ${DRIVERS_COMMON_LIBS} lidar_common)
set_target_properties(librslidar_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# vanjeelidar (single target)
file(GLOB_RECURSE VANJEE_SRCS "lidar/vanjeelidar/*.cc" "lidar/vanjeelidar/*.h" "lidar/vanjeelidar/**/*.cc" "lidar/vanjeelidar/**/*.h" "lidar/vanjeelidar/proto/*.cc" "lidar/vanjeelidar/proto/*.h")
list(FILTER VANJEE_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(libvanjeelidar_component SHARED ${VANJEE_SRCS})
target_link_libraries(libvanjeelidar_component PUBLIC ${DRIVERS_COMMON_LIBS} lidar_common)
set_target_properties(libvanjeelidar_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# compensator
file(GLOB_RECURSE COMPENSATOR_SRCS "lidar/compensator/*.cc" "lidar/compensator/*.h" "lidar/compensator/proto/*.cc" "lidar/compensator/proto/*.h")
list(FILTER COMPENSATOR_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(libcompensator_component SHARED ${COMPENSATOR_SRCS})
target_link_libraries(libcompensator_component PUBLIC ${DRIVERS_COMMON_LIBS})
set_target_properties(libcompensator_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# fusion
file(GLOB_RECURSE FUSION_SRCS "lidar/fusion/*.cc" "lidar/fusion/*.h" "lidar/fusion/proto/*.cc" "lidar/fusion/proto/*.h")
list(FILTER FUSION_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(libfusion_component SHARED ${FUSION_SRCS})
target_link_libraries(libfusion_component PUBLIC ${DRIVERS_COMMON_LIBS})
set_target_properties(libfusion_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# lidar_fusion_and_compensator
file(GLOB_RECURSE LIDAR_FUSION_SRCS "lidar_fusion_and_compensator/*.cc" "lidar_fusion_and_compensator/*.h" "lidar_fusion_and_compensator/**/proto/*.cc" "lidar_fusion_and_compensator/**/proto/*.h")
list(FILTER LIDAR_FUSION_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(lidar_fusion_and_compensator SHARED ${LIDAR_FUSION_SRCS})
target_link_libraries(lidar_fusion_and_compensator PUBLIC ${DRIVERS_COMMON_LIBS})
set_target_properties(lidar_fusion_and_compensator PROPERTIES POSITION_INDEPENDENT_CODE ON)

# microphone
file(GLOB_RECURSE MICROPHONE_SRCS "microphone/*.cc" "microphone/*.h" "microphone/**/proto/*.cc" "microphone/**/proto/*.h")
list(FILTER MICROPHONE_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(microphone_component SHARED ${MICROPHONE_SRCS})
target_link_libraries(microphone_component PUBLIC ${DRIVERS_COMMON_LIBS})
set_target_properties(microphone_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# radar - conti_radar
file(GLOB_RECURSE CONTI_RADAR_SRCS "radar/conti_radar/*.cc" "radar/conti_radar/*.h" "radar/conti_radar/**/proto/*.cc" "radar/conti_radar/**/proto/*.h" "radar/conti_radar/**/protocol/*.cc" "radar/conti_radar/**/protocol/*.h")
list(FILTER CONTI_RADAR_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(conti_radar SHARED ${CONTI_RADAR_SRCS})
target_link_libraries(conti_radar PUBLIC ${DRIVERS_COMMON_LIBS})
set_target_properties(conti_radar PROPERTIES POSITION_INDEPENDENT_CODE ON)

# radar - oculii_radar
file(GLOB_RECURSE OCULII_RADAR_SRCS "radar/oculii_radar/*.cc" "radar/oculii_radar/*.h" "radar/oculii_radar/**/proto/*.cc" "radar/oculii_radar/**/proto/*.h")
list(FILTER OCULII_RADAR_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(oculii_radar_component SHARED ${OCULII_RADAR_SRCS})
target_link_libraries(oculii_radar_component PUBLIC ${DRIVERS_COMMON_LIBS})
set_target_properties(oculii_radar_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# radar - racobit_radar
file(GLOB_RECURSE RACOBIT_RADAR_SRCS "radar/racobit_radar/*.cc" "radar/racobit_radar/*.h" "radar/racobit_radar/**/proto/*.cc" "radar/racobit_radar/**/proto/*.h" "radar/racobit_radar/**/protocol/*.cc" "radar/racobit_radar/**/protocol/*.h")
list(FILTER RACOBIT_RADAR_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(racobit_radar_canbus_component SHARED ${RACOBIT_RADAR_SRCS})
target_link_libraries(racobit_radar_canbus_component PUBLIC ${DRIVERS_COMMON_LIBS})
set_target_properties(racobit_radar_canbus_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# radar - ultrasonic_radar
file(GLOB_RECURSE ULTRASONIC_RADAR_SRCS "radar/ultrasonic_radar/*.cc" "radar/ultrasonic_radar/*.h" "radar/ultrasonic_radar/**/proto/*.cc" "radar/ultrasonic_radar/**/proto/*.h")
list(FILTER ULTRASONIC_RADAR_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(ultrasonic_radar_canbus_component SHARED ${ULTRASONIC_RADAR_SRCS})
target_link_libraries(ultrasonic_radar_canbus_component PUBLIC ${DRIVERS_COMMON_LIBS})
set_target_properties(ultrasonic_radar_canbus_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# radar - nano_radar
file(GLOB_RECURSE NANO_RADAR_SRCS "radar/nano_radar/*.cc" "radar/nano_radar/*.h" "radar/nano_radar/**/proto/*.cc" "radar/nano_radar/**/proto/*.h" "radar/nano_radar/**/protocol/*.cc" "radar/nano_radar/**/protocol/*.h")
list(FILTER NANO_RADAR_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(nano_radar SHARED ${NANO_RADAR_SRCS})
target_link_libraries(nano_radar PUBLIC ${DRIVERS_COMMON_LIBS})
set_target_properties(nano_radar PROPERTIES POSITION_INDEPENDENT_CODE ON)

# smartereye
file(GLOB_RECURSE SMARTEREYE_SRCS "smartereye/*.cc" "smartereye/*.h" "smartereye/**/proto/*.cc" "smartereye/**/proto/*.h")
list(FILTER SMARTEREYE_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(smartereye_device SHARED ${SMARTEREYE_SRCS})
target_include_directories(smartereye_device PUBLIC ${OpenCV_INCLUDE_DIRS})
target_link_libraries(smartereye_device PUBLIC ${DRIVERS_COMMON_LIBS} ${OpenCV_LIBS})
set_target_properties(smartereye_device PROPERTIES POSITION_INDEPENDENT_CODE ON)

# video
file(GLOB_RECURSE VIDEO_SRCS "video/*.cc" "video/*.h" "video/**/proto/*.cc" "video/**/proto/*.h")
list(FILTER VIDEO_SRCS EXCLUDE REGEX ".*_test.cc$|.*/tools/.*")
add_library(apollo_video_driver SHARED ${VIDEO_SRCS})
target_link_libraries(apollo_video_driver PUBLIC ${DRIVERS_COMMON_LIBS} )
set_target_properties(apollo_video_driver PROPERTIES POSITION_INDEPENDENT_CODE ON)

# tools: image_decompress component
file(GLOB_RECURSE IMAGE_DECOMPRESS_SRCS "tools/image_decompress/*.cc" "tools/image_decompress/*.h" "tools/image_decompress/proto/*.cc" "tools/image_decompress/proto/*.h")
list(FILTER IMAGE_DECOMPRESS_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(image_decompress_component SHARED ${IMAGE_DECOMPRESS_SRCS})
target_link_libraries(image_decompress_component PUBLIC ${DRIVERS_COMMON_LIBS} ${OpenCV_LIBS})
target_include_directories(image_decompress_component PUBLIC ${OpenCV_INCLUDE_DIRS})
set_target_properties(image_decompress_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# tools: video2jpg
add_executable(video2jpg
	video/tools/decode_video/video2jpg.cc
	video/tools/decode_video/frame_processor.cc
	video/tools/decode_video/frame_processor.h
	video/tools/decode_video/h265_decoder.cc
	video/tools/decode_video/h265_decoder.h
)
target_link_libraries(video2jpg PUBLIC
	common
	absl::strings
	gflags
    glog::glog
    cyberrt
    ffmepg::ffmpeg
)
