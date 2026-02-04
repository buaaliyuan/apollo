set(MAP_COMMON_LIBS
	cyberrt
	common_msg
	common
	gflags
	absl::strings
    ${PROJ_LIBRARIES}
)

# apollo_map library
file(GLOB_RECURSE MAP_SRCS
	"hdmap/adapter/*.cc"
	"hdmap/adapter/*.h"
	"hdmap/*.cc"
	"hdmap/*.h"
	"pnc_map/*.cc"
	"pnc_map/*.h"
	"relative_map/*.cc"
	"relative_map/*.h"
	"relative_map/proto/*.cc"
	"relative_map/proto/*.h"
)
list(FILTER MAP_SRCS EXCLUDE REGEX ".*_test.cc$|.*_component.cc$|.*/tools/.*")
add_library(apollo_map SHARED ${MAP_SRCS})
target_compile_definitions(apollo_map PRIVATE MODULE_NAME=\"map\")
target_link_libraries(apollo_map PUBLIC 
	${MAP_COMMON_LIBS}
	yaml-cpp
	PkgConfig::TINYXML2_LIB
)
set_target_properties(apollo_map PROPERTIES POSITION_INDEPENDENT_CODE ON)

# relative_map_component
file(GLOB RELATIVE_MAP_COMPONENT_SRCS
	"relative_map/relative_map_component.cc"
	"relative_map/relative_map_component.h"
)
add_library(relative_map_component SHARED ${RELATIVE_MAP_COMPONENT_SRCS})
target_link_libraries(relative_map_component PUBLIC apollo_map ${MAP_COMMON_LIBS})
set_target_properties(relative_map_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# Tools executables
# map_tool
add_executable(map_tool tools/map_tool.cc)
target_link_libraries(map_tool apollo_map ${MAP_COMMON_LIBS})

# map_xysl
add_executable(map_xysl tools/map_xysl.cc)
target_link_libraries(map_xysl apollo_map ${MAP_COMMON_LIBS})

# refresh_default_end_way_point
add_executable(refresh_default_end_way_point tools/refresh_default_end_way_point.cc)
target_link_libraries(refresh_default_end_way_point apollo_map ${MAP_COMMON_LIBS})

# sim_map_generator
add_executable(sim_map_generator tools/sim_map_generator.cc)
target_link_libraries(sim_map_generator apollo_map ${MAP_COMMON_LIBS})

# proto_map_generator
add_executable(proto_map_generator tools/proto_map_generator.cc)
target_link_libraries(proto_map_generator apollo_map ${MAP_COMMON_LIBS})

# bin_map_generator
add_executable(bin_map_generator tools/bin_map_generator.cc)
target_link_libraries(bin_map_generator apollo_map ${MAP_COMMON_LIBS})

# quaternion_euler
add_executable(quaternion_euler tools/quaternion_euler.cc)
target_link_libraries(quaternion_euler apollo_map ${MAP_COMMON_LIBS})

# relative_map tools
# navigator
add_executable(navigator relative_map/tools/navigator.cc)
target_link_libraries(navigator apollo_map ${MAP_COMMON_LIBS})

# navigation_dummy
add_executable(navigation_dummy relative_map/tools/navigation_dummy.cc)
target_link_libraries(navigation_dummy apollo_map ${MAP_COMMON_LIBS})
