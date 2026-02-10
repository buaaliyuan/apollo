cmake_minimum_required(VERSION 3.16)
project(apollo LANGUAGES C CXX ASM)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Build output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/static_lib)

# ──────────────────────────────────────────────
# Options
# ──────────────────────────────────────────────
option(APOLLO_USE_GPU    "Enable GPU (CUDA) support"          ON)
option(APOLLO_BUILD_TESTS "Build unit tests"                  OFF)
option(APOLLO_BUILD_CYBER   "Build CyberRT module"              ON)
option(APOLLO_BUILD_MODULES "Build Apollo modules"              ON)
option(APOLLO_BUILD_FRONTEND "Build frontend (dreamview/dreamview_plus)" OFF)

# ──────────────────────────────────────────────
# Global compile flags
# ──────────────────────────────────────────────
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

if(APOLLO_USE_GPU)
    enable_language(CUDA)
    find_package(CUDA REQUIRED)
    add_compile_definitions(USE_GPU=1)
    include_directories(${CUDA_INCLUDE_DIRS})
    message(STATUS "CUDA include dirs: ${CUDA_INCLUDE_DIRS}")
endif()

# ──────────────────────────────────────────────
# Project-wide include paths
# ──────────────────────────────────────────────
# Allow #include "cyber/..." from project root
include_directories(${CMAKE_SOURCE_DIR})
# Allow #include for generated protobuf headers
include_directories(${CMAKE_BINARY_DIR})

# ──────────────────────────────────────────────
# CMake module path
# ──────────────────────────────────────────────
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# ──────────────────────────────────────────────
# Third-party dependencies (consolidated)
# ──────────────────────────────────────────────
include(ThirdPartyDeps)

# ──────────────────────────────────────────────
# Utility functions (apollo_cc_library, etc.)
# ──────────────────────────────────────────────
include(ApolloUtils)

# ──────────────────────────────────────────────
# Sub-directories
# ──────────────────────────────────────────────
if(APOLLO_BUILD_CYBER)
    add_subdirectory(cyber)
endif()

if(APOLLO_BUILD_MODULES)
    add_subdirectory(modules)
endif()

# ──────────────────────────────────────────────
# Install rules
# ──────────────────────────────────────────────
# Default install prefix: /apollo (matches DAG relative paths)
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "/apollo" CACHE PATH "Install prefix" FORCE)
endif()

# Install libcyber.so to lib/ (shared runtime library)
if(APOLLO_BUILD_CYBER)
    install(TARGETS cyber
        LIBRARY DESTINATION lib
    )
endif()

# Install conf / dag / launch data files preserving source-relative paths
# so that DAG module_library paths and config_file_path references work.
install(DIRECTORY modules/
    DESTINATION modules
    FILES_MATCHING
        PATTERN "*.dag"
        PATTERN "*.launch"
        PATTERN "*.conf"
        PATTERN "*.pb.txt"
        PATTERN "*.pt"        # model files
)

# Install cyber conf and tools
install(DIRECTORY cyber/conf/
    DESTINATION cyber/conf
)
install(FILES cyber/setup.bash
    DESTINATION cyber
)
install(DIRECTORY scripts/
    DESTINATION scripts
)

install(DIRECTORY cyber/tools/
    DESTINATION cyber/tools
    FILES_MATCHING
        PATTERN "*.py" EXCLUDE
)

# cyber 日志目录
# Create data/log directory
install(CODE "file(MAKE_DIRECTORY \"\${CMAKE_INSTALL_PREFIX}/data/log\")")


# python 工具安装
# Install Python tools without .py extension and with executable permissions
install(PROGRAMS
    cyber/tools/cyber_performance/cyber_performance.py
    DESTINATION cyber/tools
    RENAME cyber_performance
)
install(PROGRAMS
    cyber/tools/cyber_node/cyber_node.py
    DESTINATION cyber/tools
    RENAME cyber_node
)
install(PROGRAMS
    cyber/tools/cyber_channel/cyber_channel.py
    DESTINATION cyber/tools
    RENAME cyber_channel
)
install(PROGRAMS
    cyber/tools/cyber_service/cyber_service.py
    DESTINATION cyber/tools
    RENAME cyber_service
)
install(PROGRAMS
    cyber/tools/cyber_launch/cyber_launch.py
    DESTINATION cyber/tools
    RENAME cyber_launch
)

