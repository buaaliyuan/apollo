file(GLOB_RECURSE SRCS "*.cc" "*.h")
list(FILTER SRCS EXCLUDE REGEX ".*_test.cc$|.*/tools/.*\\.cc$")

add_library(control_component SHARED 
	${SRCS}
)

target_link_libraries(control_component PUBLIC
	cyberrt
	common_msg
	common
	absl::strings
	gflags
    sqlite3
)
set_target_properties(control_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

add_executable(control_tester
	tools/control_tester.cc
)
target_link_libraries(control_tester PUBLIC
	control_component
	cyberrt
	common_msg
	common
	gflags
)

add_executable(pad_terminal
	tools/pad_terminal.cc
)
target_link_libraries(pad_terminal PUBLIC
	control_component
	cyberrt
	common_msg
	common
	gflags
)

add_executable(calibration_table_debug
	tools/calibration_table_debug.cc
)
target_link_libraries(calibration_table_debug PUBLIC
	control_component
	cyberrt
	common_msg
	common
	gflags
)
