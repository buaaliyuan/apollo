file(GLOB_RECURSE safety_proto_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER safety_proto_srcs EXCLUDE REGEX ".*_test.cc$")

add_library(safety_msg_proto SHARED 
    ${safety_proto_srcs} 
)
target_link_libraries(safety_msg_proto
PUBLIC
    protobuf::libprotobuf
)
target_include_directories(safety_msg_proto PRIVATE ${CMAKE_SOURCE_DIR})

install(TARGETS safety_msg_proto
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)