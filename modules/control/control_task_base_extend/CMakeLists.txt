file(GLOB_RECURSE SRCS "*.cc" "*.h")
list(FILTER SRCS EXCLUDE REGEX ".*_test.cc$")

add_library(control_task_extend SHARED 
    ${SRCS}
)

target_link_libraries(control_task_extend PUBLIC
    control_component
    cyberrt
    common_msg
    common
    absl::strings
    gflags
)
set_target_properties(control_task_extend PROPERTIES POSITION_INDEPENDENT_CODE ON)
