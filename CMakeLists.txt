cmake_minimum_required(VERSION 3.19)
project(AIPilot)
enable_language(ASM CUDA)

set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH};/usr/local/fast-rtps)
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_STANDARD 17)
include(cmake/find_thirdparty.cmake)
add_subdirectory(cyber)