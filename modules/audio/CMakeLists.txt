file(GLOB_RECURSE SRCS "*.cc" "*.h")
list(FILTER SRCS EXCLUDE REGEX ".*_test.cc$|.*processing\\.cc$")

add_library(audio_component SHARED 
    ${SRCS}
)
target_link_libraries(audio_component PUBLIC
    cyberrt
    common_msg
    Eigen3::Eigen
)
set_target_properties(audio_component PROPERTIES POSITION_INDEPENDENT_CODE ON)