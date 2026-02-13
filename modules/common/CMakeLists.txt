file(GLOB_RECURSE COMMON_SOURCES "*.cc")
list(FILTER COMMON_SOURCES EXCLUDE REGEX ".*_test.cc$")

add_library(modules_common SHARED ${COMMON_SOURCES})
target_link_libraries(modules_common 
PUBLIC 
    cyber
    osqp
    gtest_headers
    msg_proto
)

install(TARGETS modules_common
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)