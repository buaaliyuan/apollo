file(GLOB cyber_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER cyber_srcs EXCLUDE REGEX ".*_test.cc$")

target_sources(cyber
PRIVATE
    ${cyber_srcs}
)

add_subdirectory(common)
add_subdirectory(dispatcher)
add_subdirectory(message)
add_subdirectory(qos)
add_subdirectory(receiver)
add_subdirectory(rtps)
add_subdirectory(shm)
add_subdirectory(transmitter)