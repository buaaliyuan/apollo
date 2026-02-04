set(GUARDIAN_COMMON_LIBS
	cyberrt
	common_msg
	common
	gflags
)

file(GLOB_RECURSE GUARDIAN_SRCS
	"guardian_component.cc"
	"guardian_component.h"
	"proto/*.cc"
	"proto/*.h"
)
list(FILTER GUARDIAN_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(guardian_component SHARED ${GUARDIAN_SRCS})
target_compile_definitions(guardian_component PRIVATE MODULE_NAME=\"guardian\")
target_link_libraries(guardian_component PUBLIC ${GUARDIAN_COMMON_LIBS})
set_target_properties(guardian_component PROPERTIES POSITION_INDEPENDENT_CODE ON)
