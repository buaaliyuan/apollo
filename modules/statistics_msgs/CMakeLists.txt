file(GLOB_RECURSE statistics_proto_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER statistics_proto_srcs EXCLUDE REGEX ".*_test.cc$")

add_library(statistics_msg_proto SHARED 
    ${statistics_proto_srcs} 
)
target_link_libraries(statistics_msg_proto
PUBLIC
    protobuf::libprotobuf
)
target_include_directories(statistics_msg_proto PRIVATE ${CMAKE_SOURCE_DIR})

install(TARGETS statistics_msg_proto
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)