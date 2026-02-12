file(GLOB cyber_proto_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER cyber_proto_srcs EXCLUDE REGEX ".*_test.cc$")

add_library(cyber_proto SHARED 
    ${cyber_proto_srcs} 
    ${CMAKE_SOURCE_DIR}/cyber/benchmark/benchmark_msg.pb.cc
    ${CMAKE_SOURCE_DIR}/cyber/examples/proto/examples.pb.cc 
)
target_link_libraries(cyber_proto
PUBLIC
    protobuf::libprotobuf
)
target_include_directories(cyber_proto PRIVATE ${CMAKE_SOURCE_DIR})

install(TARGETS cyber_proto
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)