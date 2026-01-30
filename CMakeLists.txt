cmake_minimum_required(VERSION 3.19)
project(AIPilot)
enable_language(ASM CUDA)

set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH};/usr/local/fast-rtps;/opt/apollo/sysroot;/opt/apollo)
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
include(cmake/find_thirdparty.cmake)

# process all the proto files
file(GLOB_RECURSE PROTO_FILES "modules/*.proto" "cyber/*.proto")
foreach(protofile ${PROTO_FILES})
    get_filename_component(protodir "${protofile}" DIRECTORY)
    get_filename_component(protoname "${protofile}" NAME_WE)
    set(pb_h "${protodir}/${protoname}.pb.h")
    
    set(need_generate FALSE)
    if(NOT EXISTS "${pb_h}")
        set(need_generate TRUE)
    else()
        FILE(TIMESTAMP "${protofile}" proto_ts "%s")
        FILE(TIMESTAMP "${pb_h}" pb_ts "%s")
        if(proto_ts GREATER pb_ts)
            set(need_generate TRUE)
        endif()
    endif()
    
    if(need_generate)
        message(STATUS "Generating ${protoname}")
        execute_process(COMMAND ${Protobuf_PROTOC_EXECUTABLE}
            --cpp_out=${PROJECT_SOURCE_DIR}
            --proto_path=${PROJECT_SOURCE_DIR}
            ${protofile}
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        )
    endif()
endforeach()

# add global include directories
include_directories(${CMAKE_SOURCE_DIR})

# compile subdirectories
add_subdirectory(cyber)
add_subdirectory(modules/audio)
add_subdirectory(modules/common_msgs)
add_subdirectory(modules/common)
add_subdirectory(modules/bridge)
add_subdirectory(modules/canbus)
add_subdirectory(modules/canbus_vehicle)