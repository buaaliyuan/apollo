set(cyber_subdir_list
    "base"
    "benchmark"
    "blocker"
    "class_loader"
    "common"
    "component"
    "context"
    "croutine"
    "data"
    "event"
    "examples"
    "io"
    "logger"
    "mainboard"
    "message"
    "node"
    "parameter"
    "plugin_manager"
    "profiler"
    "proto"
    "python"
    "record"
    "scheduler"
    "service"
    "service_discovery"
    "statistics"
    "sysmo"
    "task"
    "time"
    "timer"
    "tools"
    "transport"
)
add_library(cyber SHARED)

file(GLOB cyber_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER cyber_srcs EXCLUDE REGEX ".*_test.cc$")

target_sources(cyber
PRIVATE
    ${cyber_srcs}
)

target_link_libraries(cyber
PUBLIC
    rt
    atomic
    dl
    m
    fastrtps
    nlohmann_json
    pthread
    protobuf::libprotobuf
    glog::glog
    gflags
    absl
    bvar
    gperftools
    uuid
    cyber_proto
)

target_include_directories(cyber
PUBLIC
    ${CMAKE_SOURCE_DIR}
)

install(TARGETS cyber
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)

install(DIRECTORY conf
    DESTINATION cyber
)

install(DIRECTORY proto
    DESTINATION cyber
    FILES_MATCHING PATTERN "*.py"
)

install(DIRECTORY tools
    DESTINATION cyber
    FILES_MATCHING PATTERN "*.bash"
)

foreach(subdir ${cyber_subdir_list})
    add_subdirectory(${subdir})
endforeach()
