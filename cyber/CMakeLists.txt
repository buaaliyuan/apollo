file(GLOB_RECURSE PROTO_FILES "*.proto")

foreach(protofile ${PROTO_FILES})
    message(STATUS "Processing ${protofile}")
    get_filename_component(protodir "${protofile}" DIRECTORY)
    execute_process(COMMAND ${Protobuf_PROTOC_EXECUTABLE}
        --cpp_out=${PROJECT_SOURCE_DIR}
        --proto_path=${PROJECT_SOURCE_DIR}
        ${protofile}
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    )
    #message(STATUS "== ${protofile} == ${protodir}")
    #message(STATUS "Generated C++ files in ${PROJECT_SOURCE_DIR}")
endforeach()

set(cyber_dir_list 
    "base"
    # "benchmark"
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
set(target_name cyber)
add_library(${target_name} SHARED ${CPPS} ${HPPS})
set_target_properties(${target_name} PROPERTIES POSITION_INDEPENDENT_CODE ON)
target_include_directories(${target_name} PUBLIC 
    ${PROJECT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}
)
target_link_libraries(${target_name} PUBLIC 
    protobuf::libprotobuf
    PkgConfig::UUID_LIB
    PkgConfig::TINYXML2_LIB
    PkgConfig::PYTHON3.6_LIB
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
    ${target_name}
    PkgConfig::TCMALLOC_LIB
    PkgConfig::PROFILER_LIB
)
target_link_libraries(cyber_benchmark_writer PUBLIC 
    ${target_name}
    PkgConfig::TCMALLOC_LIB
    PkgConfig::PROFILER_LIB
)