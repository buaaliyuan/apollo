cmake_minimum_required(VERSION 3.16)
project(apollo LANGUAGES C CXX ASM)
enable_language(CUDA)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_SYSTEM_PROCESSOR ${CMAKE_HOST_SYSTEM_PROCESSOR})

message(STATUS "=== CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}")

# Build output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

option(APOLLO_BUILD_CYBER   "Build CyberRT module"              ON)
option(APOLLO_BUILD_MODULES "Build Apollo modules"              ON)
option(APOLLO_BUILD_FRONTEND "Build frontend (dreamview/dreamview_plus)" OFF)
option(APOLLO_USE_GPU "Use GPU for perception and planning" ON)

add_compile_options(
    -Wall
    -Wextra
    -Wno-unused-parameter
    -Wno-missing-field-initializers
    -O2
)

if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64")
    add_compile_definitions(APOLLO_X86_64=1)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
    add_compile_definitions(APOLLO_AARCH64=1)
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include(ThirdPartyDeps)

file(GLOB_RECURSE PROTO_FILES "modules/*.proto" "cyber/*.proto")
foreach(protofile ${PROTO_FILES})
    get_filename_component(protodir ${protofile} DIRECTORY)
    get_filename_component(protoname ${protofile} NAME_WE)
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
        execute_process(COMMAND ${Protobuf_PROTOC_EXECUTABLE}
            --cpp_out=${PROJECT_SOURCE_DIR}
            --proto_path=${PROJECT_SOURCE_DIR}
            ${protofile}
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        )
        execute_process(COMMAND ${Protobuf_PROTOC_EXECUTABLE}
            --python_out=${PROJECT_SOURCE_DIR}
            --proto_path=${PROJECT_SOURCE_DIR}
            ${protofile}
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        )
    endif()
endforeach()


if(APOLLO_BUILD_CYBER)
    add_subdirectory(cyber)
endif()

if(APOLLO_BUILD_MODULES)
    add_subdirectory(modules)
endif()

# Install directories，用于存放日志
install(DIRECTORY DESTINATION data/log)

