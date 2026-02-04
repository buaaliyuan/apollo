set(MONITOR_COMMON_LIBS
	cyberrt
	common_msg
	common
	absl::strings
	gflags
)

file(GLOB_RECURSE MONITOR_LIB_SRCS
	"common/*.cc"
	"common/*.h"
	"hardware/*.cc"
	"hardware/*.h"
	"software/*.cc"
	"software/*.h"
)
list(FILTER MONITOR_LIB_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(apollo_monitor SHARED ${MONITOR_LIB_SRCS})
target_link_libraries(apollo_monitor PUBLIC ${MONITOR_COMMON_LIBS})
set_target_properties(apollo_monitor PROPERTIES POSITION_INDEPENDENT_CODE ON)

file(GLOB MONITOR_COMPONENT_SRCS "monitor.cc" "monitor.h")
add_library(monitor SHARED ${MONITOR_COMPONENT_SRCS})
target_compile_definitions(monitor PRIVATE MODULE_NAME=\"monitor\")
target_link_libraries(monitor PUBLIC apollo_monitor ${MONITOR_COMMON_LIBS})
set_target_properties(monitor PROPERTIES POSITION_INDEPENDENT_CODE ON)
