file(GLOB_RECURSE SRCS "*.cc" "*.h")
add_library(common_msg SHARED ${SRCS})
target_link_libraries(common_msg 
PUBLIC 
    protobuf::libprotobuf
)