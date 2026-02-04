set(TRANSFORM_COMMON_LIBS
	cyberrt
	common_msg
	common
	gflags
)

# apollo_transform library
file(GLOB TRANSFORM_LIB_SRCS
	"buffer.cc"
	"buffer.h"
	"buffer_interface.h"
	"transform_broadcaster.cc"
	"transform_broadcaster.h"
)
add_library(apollo_transform SHARED ${TRANSFORM_LIB_SRCS})
target_link_libraries(apollo_transform PUBLIC ${TRANSFORM_COMMON_LIBS} tf2)
set_target_properties(apollo_transform PROPERTIES POSITION_INDEPENDENT_CODE ON)

# static_transform_component
file(GLOB_RECURSE STATIC_TRANSFORM_COMPONENT_SRCS
	"static_transform_component.cc"
	"static_transform_component.h"
	"proto/*.cc"
	"proto/*.h"
)
add_library(static_transform_component SHARED ${STATIC_TRANSFORM_COMPONENT_SRCS})
target_compile_definitions(static_transform_component PRIVATE MODULE_NAME=\"static_transform\")
target_link_libraries(static_transform_component PUBLIC ${TRANSFORM_COMMON_LIBS} yaml-cpp)
set_target_properties(static_transform_component PROPERTIES POSITION_INDEPENDENT_CODE ON)
