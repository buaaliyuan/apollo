set(LOCALIZATION_COMMON_LIBS
	cyberrt
	common_msg
	common
	gflags
    Boost::program_options
)

# msf base library
file(GLOB_RECURSE MSF_BASE_SRCS
	"msf/*.cc"
	"msf/*.h"
	"msf/**/proto/*.cc"
	"msf/**/proto/*.h"
    "common/*.cc"
)
list(FILTER MSF_BASE_SRCS EXCLUDE REGEX ".*_test.cc$|.*/local_tool/.*")
add_library(apollo_localization_msf SHARED ${MSF_BASE_SRCS})
target_compile_definitions(apollo_localization_msf PRIVATE MODULE_NAME=\"localization\")
target_include_directories(apollo_localization_msf PUBLIC ${OpenCV_INCLUDE_DIRS})
target_link_libraries(apollo_localization_msf PUBLIC 
    ${LOCALIZATION_COMMON_LIBS} 
    localization_msf::localization_msf
    pcl::pcl
    ${OpenCV_LIBS}
    yaml-cpp
    ${PROJ_LIBRARIES}
    apollo_transform
)
set_target_properties(apollo_localization_msf PROPERTIES POSITION_INDEPENDENT_CODE ON)

# local_tool binaries
# compare_poses
add_executable(compare_poses msf/local_tool/data_extraction/compare_poses.cc)
target_link_libraries(compare_poses apollo_localization_msf ${LOCALIZATION_COMMON_LIBS} )

# cyber_record_parser
file(GLOB DATA_EXTRACTION_SRCS
	"msf/local_tool/data_extraction/cyber_record_reader.cc"
	"msf/local_tool/data_extraction/location_exporter.cc"
	"msf/local_tool/data_extraction/pcd_exporter.cc"
	"msf/local_tool/data_extraction/cyber_record_parser.cc"
)
add_executable(cyber_record_parser ${DATA_EXTRACTION_SRCS})
target_link_libraries(cyber_record_parser PUBLIC 
    apollo_localization_msf 
    ${LOCALIZATION_COMMON_LIBS}
    Boost::program_options
)

# lossless_map_creator
add_executable(lossless_map_creator msf/local_tool/map_creation/lossless_map_creator.cc)
target_link_libraries(lossless_map_creator apollo_localization_msf ${LOCALIZATION_COMMON_LIBS})

# lossless_map_to_lossy_map
add_executable(lossless_map_to_lossy_map msf/local_tool/map_creation/lossless_map_to_lossy_map.cc)
target_link_libraries(lossless_map_to_lossy_map apollo_localization_msf ${LOCALIZATION_COMMON_LIBS})

# poses_interpolator
file(GLOB POSES_INTERPOLATOR_SRCS
	"msf/local_tool/map_creation/poses_interpolation/*.cc"
	"msf/local_tool/map_creation/poses_interpolator.cc"
)
add_executable(poses_interpolator ${POSES_INTERPOLATOR_SRCS})
target_include_directories(poses_interpolator PRIVATE
    ${PROJ_INCLUDE_DIRS}
)
target_link_libraries(poses_interpolator PRIVATE
    apollo_localization_msf 
    ${LOCALIZATION_COMMON_LIBS} 
    Boost::program_options
)

# online_visualizer_component (shared library)
file(GLOB ONLINE_VISUALIZER_SRCS
	"msf/local_tool/local_visualization/online_visual/online_visualizer_component.cc"
	"msf/local_tool/local_visualization/online_visual/online_visualizer_component.h"
)
add_library(online_visualizer_component SHARED ${ONLINE_VISUALIZER_SRCS})
target_link_libraries(online_visualizer_component PUBLIC apollo_localization_msf ${LOCALIZATION_COMMON_LIBS} pcl::pcl)
set_target_properties(online_visualizer_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# msf component
file(GLOB MSF_COMPONENT_SRCS
	"msf/msf_localization*.cc"
	"msf/msf_localization*.h"
)
list(FILTER MSF_COMPONENT_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(msf_localization_component SHARED ${MSF_COMPONENT_SRCS})
target_compile_definitions(msf_localization_component PRIVATE MODULE_NAME=\"localization\")
target_link_libraries(msf_localization_component PUBLIC apollo_localization_msf ${LOCALIZATION_COMMON_LIBS})
set_target_properties(msf_localization_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# ndt locator
file(GLOB NDT_LOCATOR_SRCS
	"ndt/ndt_locator/*.cc"
	"ndt/ndt_locator/*.h"
)
list(FILTER NDT_LOCATOR_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(ndt_lidar_locator SHARED ${NDT_LOCATOR_SRCS})
target_link_libraries(ndt_lidar_locator PUBLIC apollo_localization_msf ${LOCALIZATION_COMMON_LIBS})
set_target_properties(ndt_lidar_locator PROPERTIES POSITION_INDEPENDENT_CODE ON)

# ndt component
file(GLOB NDT_COMPONENT_SRCS
	"ndt/*.cc"
	"ndt/*.h"
)
list(FILTER NDT_COMPONENT_SRCS EXCLUDE REGEX ".*_test.cc$|.*/ndt_locator/.*")
add_library(ndt_localization_component SHARED ${NDT_COMPONENT_SRCS})
target_compile_definitions(ndt_localization_component PRIVATE MODULE_NAME=\"NDTlocalization\")
target_link_libraries(ndt_localization_component PUBLIC ndt_lidar_locator apollo_localization_msf ${LOCALIZATION_COMMON_LIBS})
set_target_properties(ndt_localization_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# rtk component
file(GLOB RTK_COMPONENT_SRCS
	"rtk/*.cc"
	"rtk/*.h"
)
list(FILTER RTK_COMPONENT_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(rtk_localization_component SHARED ${RTK_COMPONENT_SRCS})
target_compile_definitions(rtk_localization_component PRIVATE MODULE_NAME=\"localization\")
target_link_libraries(rtk_localization_component PUBLIC ${LOCALIZATION_COMMON_LIBS})
set_target_properties(rtk_localization_component PROPERTIES POSITION_INDEPENDENT_CODE ON)
