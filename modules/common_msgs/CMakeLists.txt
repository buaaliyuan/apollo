file(GLOB_RECURSE msg_proto_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER msg_proto_srcs EXCLUDE REGEX ".*_test.cc$")

add_library(msg_proto SHARED 
    ${msg_proto_srcs} 
)
target_link_libraries(msg_proto
PUBLIC
    protobuf::libprotobuf
)
target_include_directories(msg_proto PRIVATE ${CMAKE_SOURCE_DIR})

install(TARGETS msg_proto
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)