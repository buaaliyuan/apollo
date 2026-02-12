file(GLOB cyber_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER cyber_srcs EXCLUDE REGEX ".*_test.cc$")

target_sources(cyber
PRIVATE
    ${cyber_srcs}
)
add_subdirectory(file)