set(cyber_dir_list 
    "base"
    "blocker"
    "class_loader"
    "common"
    "component"
    "context"
    "croutine"
    "data"
    "event"
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
    "transport"
)

# add all cpp and hpp files in the cyber subdirectories
foreach(dir_item ${cyber_dir_list})
    if(NOT IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${dir_item}")
        message(FATAL_ERROR "Directory '${dir_item}' does not exist in ${CMAKE_CURRENT_SOURCE_DIR}")
    endif()
    
    file(GLOB_RECURSE TMP_CPPS ${dir_item}/*.cpp ${dir_item}/*.cc)
    file(GLOB_RECURSE TMP_HPPS ${dir_item}/*.h ${dir_item}/*.hpp)
    list(APPEND CPPS ${TMP_CPPS})
    list(APPEND HPPS ${TMP_HPPS})
endforeach()

# add cpp and hpp files in the current cyber directory
file(GLOB TMP_CPPS *.cpp *.cc)
file(GLOB TMP_HPPS *.h *.hpp)
list(APPEND CPPS ${TMP_CPPS})
list(APPEND HPPS ${TMP_HPPS})

# add architecture-specific assembly files
if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
    file(GLOB_RECURSE swap_asm swap_x86_64.S)
endif()
list(APPEND CPPS ${swap_asm})

# filter out test files from the source list
list(FILTER CPPS EXCLUDE REGEX ".*test\\.cc$|tcp_echo.*\\.cc$|udp_echo.*\\.cc$")

# create the cyber shared library
add_library(cyberrt SHARED ${CPPS} ${HPPS})

target_include_directories(cyberrt 
PUBLIC 
    ${PROJECT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${fastrtps_INCLUDE_DIR}
)
target_link_libraries(cyberrt 
PUBLIC
    protobuf::libprotobuf
    PkgConfig::UUID_LIB
    PkgConfig::TINYXML2_LIB
    PkgConfig::PYTHON3.6_LIB
    PkgConfig::TCMALLOC_LIB
    PkgConfig::PROFILER_LIB
    fastrtps
    fastcdr
    glog::glog
    gflags
    Boost::filesystem
    gtest
    gmock
    nlohmann_json
    bvar::bvar
    atomic
    rt
)
set_target_properties(cyberrt PROPERTIES POSITION_INDEPENDENT_CODE ON)
# compile benchmark
add_executable(cyber_benchmark_reader 
    benchmark/cyber_benchmark_reader.cc
    benchmark/benchmark_msg.pb.cc
    benchmark/benchmark_msg.pb.h
)
add_executable(cyber_benchmark_writer 
    benchmark/cyber_benchmark_writer.cc
    benchmark/benchmark_msg.pb.cc
    benchmark/benchmark_msg.pb.h
)
target_link_libraries(cyber_benchmark_reader PUBLIC 
    cyberrt
)
target_link_libraries(cyber_benchmark_writer PUBLIC 
    cyberrt
)

# compile tools
file(GLOB CYBER_MONITOR_SRCS "tools/cyber_monitor/*.cc")
file(GLOB CYBER_MONITOR_HDRS "tools/cyber_monitor/*.h")
add_executable(cyber_monitor ${CYBER_MONITOR_HDRS} ${CYBER_MONITOR_SRCS})
target_link_libraries(cyber_monitor PUBLIC 
    cyberrt
    PkgConfig::NCURSES_LIB
)

file(GLOB_RECURSE CYBER_REC_SRCS "tools/cyber_recorder/*.cc")
file(GLOB_RECURSE CYBER_REC_HDRS "tools/cyber_recorder/*.h")
add_executable(cyber_recorder ${CYBER_REC_SRCS} ${CYBER_REC_HDRS})
target_link_libraries(cyber_recorder PUBLIC 
    cyberrt
)
