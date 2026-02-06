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
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# ──────────────────────────────────────────────
# Options
# ──────────────────────────────────────────────
option(APOLLO_USE_GPU    "Enable GPU (CUDA) support"          OFF)
option(APOLLO_BUILD_TESTS "Build unit tests"                  OFF)
option(APOLLO_BUILD_CYBER   "Build CyberRT module"              ON)
option(APOLLO_BUILD_MODULES "Build Apollo modules"              ON)

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
