# ============================================================================
# ThirdPartyDeps.cmake
# Consolidated third-party library definitions for Apollo project.
# Tuned for the Apollo Docker development container.
# Mirrors: third_party/ Bazel BUILD definitions + WORKSPACE
# ============================================================================

# ──────────────────────────────────────────────
# System library search paths (Apollo Docker)
# ──────────────────────────────────────────────
set(APOLLO_SYSROOT "/opt/apollo/sysroot" CACHE PATH "Apollo sysroot path")
set(FASTRTPS_ROOT "/usr/local/fast-rtps" CACHE PATH "FastRTPS install prefix")

link_directories(
    /usr/local/lib
    /usr/lib/x86_64-linux-gnu
    ${APOLLO_SYSROOT}/lib
    ${FASTRTPS_ROOT}/lib
)

# ============================================================================
# 1. Protobuf  (system, protoc at /usr/bin/protoc, libs at /usr/lib/x86_64-linux-gnu)
# Mirrors: third_party/protobuf
# ============================================================================
set(Protobuf_INCLUDE_DIR "/usr/include" CACHE PATH "")
set(Protobuf_LIBRARY "/usr/lib/x86_64-linux-gnu/libprotobuf.so" CACHE FILEPATH "")
set(Protobuf_PROTOC_EXECUTABLE "/usr/bin/protoc" CACHE FILEPATH "")
find_package(Protobuf REQUIRED)
message(STATUS "Protobuf: ${Protobuf_VERSION}, protoc=${Protobuf_PROTOC_EXECUTABLE}")

# ============================================================================
# 2. gflags  (/usr/local)
# Mirrors: third_party/gflags/gflags.BUILD  → -lgflags
# ============================================================================
find_package(gflags REQUIRED PATHS /usr/local/lib/cmake/gflags NO_DEFAULT_PATH)
message(STATUS "Found gflags: ${gflags_VERSION}")

# ============================================================================
# 3. glog  (/usr/local)
# Mirrors: third_party/glog/glog.BUILD  → -lglog
# ============================================================================
find_package(glog REQUIRED PATHS /usr/local/lib/cmake/glog NO_DEFAULT_PATH)
message(STATUS "Found glog: ${glog_VERSION}")

# ============================================================================
# 4. Eigen3  (bundled in thirdparty/)
# Mirrors: third_party/eigen3/eigen.BUILD
# ============================================================================
if(EXISTS "${CMAKE_SOURCE_DIR}/thirdparty/install/include/eigen3")
    set(EIGEN3_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/thirdparty/install/include/eigen3")
elseif(EXISTS "${CMAKE_SOURCE_DIR}/thirdparty/eigen-git-mirror-3.3.7")
    set(EIGEN3_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/thirdparty/eigen-git-mirror-3.3.7")
endif()
if(EIGEN3_INCLUDE_DIR)
    add_library(eigen INTERFACE)
    target_include_directories(eigen INTERFACE ${EIGEN3_INCLUDE_DIR})
    add_library(Eigen3::Eigen ALIAS eigen)
    message(STATUS "Eigen3: ${EIGEN3_INCLUDE_DIR}")
else()
    find_package(Eigen3 3.3 QUIET)
    if(Eigen3_FOUND)
        message(STATUS "Found Eigen3: ${Eigen3_VERSION}")
    else()
        message(WARNING "Eigen3 not found")
    endif()
endif()

# ============================================================================
# 5. Google Test (optional, for tests)
# Mirrors: third_party/gtest
# ============================================================================
# gtest headers are needed even in non-test builds (for FRIEND_TEST macro)
set(GTEST_INCLUDE_DIR "/usr/src/googletest/googletest/include" CACHE PATH "")
if(EXISTS "${GTEST_INCLUDE_DIR}/gtest/gtest.h")
    add_library(gtest_headers INTERFACE)
    target_include_directories(gtest_headers INTERFACE ${GTEST_INCLUDE_DIR})
    message(STATUS "GTest headers: ${GTEST_INCLUDE_DIR}")
endif()
if(APOLLO_BUILD_TESTS)
    find_package(GTest REQUIRED)
    message(STATUS "Found GTest: ${GTest_VERSION}")
endif()

# ============================================================================
# 6. FastRTPS / FastDDS  (/usr/local/fast-rtps)
# Mirrors: third_party/fastdds/fastdds.BUILD  → -lfastrtps -lfastcdr
# ============================================================================
add_library(fastrtps INTERFACE)
target_include_directories(fastrtps INTERFACE
    ${FASTRTPS_ROOT}/include
    ${FASTRTPS_ROOT}/include/fastrtps
    ${FASTRTPS_ROOT}/include/fastcdr
)
target_link_directories(fastrtps INTERFACE ${FASTRTPS_ROOT}/lib)
target_link_libraries(fastrtps INTERFACE -lfastrtps -lfastcdr)
add_library(FastRTPS::FastRTPS ALIAS fastrtps)
message(STATUS "FastRTPS: ${FASTRTPS_ROOT}")

# ============================================================================
# 7. nlohmann_json  (fetched by bazel, available in build/_deps)
# Mirrors: third_party/nlohmann_json/json.BUILD
# ============================================================================
find_package(nlohmann_json QUIET)
if(NOT nlohmann_json_FOUND)
    set(_nlohmann_search_paths
        "${CMAKE_SOURCE_DIR}/build/_deps/nlohmann-src/include"
        "${CMAKE_SOURCE_DIR}/thirdparty/json-3.8.0/include"
    )
    set(_nlohmann_found FALSE)
    foreach(_p ${_nlohmann_search_paths})
        if(EXISTS "${_p}/nlohmann/json.hpp")
            add_library(nlohmann_json_impl INTERFACE)
            target_include_directories(nlohmann_json_impl INTERFACE ${_p})
            add_library(nlohmann_json::nlohmann_json ALIAS nlohmann_json_impl)
            add_library(nlohmann_json ALIAS nlohmann_json_impl)
            message(STATUS "nlohmann_json: ${_p}")
            set(_nlohmann_found TRUE)
            break()
        endif()
    endforeach()
    if(NOT _nlohmann_found)
        include(FetchContent)
        FetchContent_Declare(nlohmann_json
            URL https://github.com/nlohmann/json/archive/v3.8.0.tar.gz
            URL_HASH SHA256=7d0edf65f2ac7390af5e5a0b323b31202a6c11d744a74b588dc30f5a8c9865ba
        )
        FetchContent_MakeAvailable(nlohmann_json)
        message(STATUS "nlohmann_json: fetched v3.8.0")
    endif()
else()
    message(STATUS "Found nlohmann_json: ${nlohmann_json_VERSION}")
endif()

# ============================================================================
# 8. Boost  (/opt/apollo/sysroot)
# Mirrors: third_party/boost/boost.BUILD
# ============================================================================
set(BOOST_ROOT "${APOLLO_SYSROOT}" CACHE PATH "Boost root path")
set(Boost_DIR "${APOLLO_SYSROOT}/lib/cmake/Boost-1.74.0" CACHE PATH "")
find_package(Boost 1.74 REQUIRED COMPONENTS filesystem program_options regex system thread)
message(STATUS "Found Boost: ${Boost_VERSION}")

# ============================================================================
# 9. yaml-cpp
# Mirrors: third_party/yaml_cpp/yaml_cpp.BUILD
# ============================================================================
find_package(yaml-cpp QUIET)
if(NOT yaml-cpp_FOUND)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
        pkg_check_modules(YAMLCPP yaml-cpp)
    endif()
    if(YAMLCPP_FOUND)
        add_library(yaml-cpp INTERFACE)
        target_include_directories(yaml-cpp INTERFACE ${YAMLCPP_INCLUDE_DIRS})
        target_link_libraries(yaml-cpp INTERFACE ${YAMLCPP_LIBRARIES})
    else()
        if(EXISTS "${CMAKE_SOURCE_DIR}/thirdparty/yaml-cpp-yaml-cpp-0.6.3/CMakeLists.txt")
            set(YAML_CPP_BUILD_TESTS OFF CACHE BOOL "" FORCE)
            set(YAML_CPP_BUILD_TOOLS OFF CACHE BOOL "" FORCE)
            add_subdirectory(${CMAKE_SOURCE_DIR}/thirdparty/yaml-cpp-yaml-cpp-0.6.3
                             ${CMAKE_BINARY_DIR}/_deps/yaml-cpp-build EXCLUDE_FROM_ALL)
            message(STATUS "yaml-cpp: building from thirdparty/")
        else()
            add_library(yaml-cpp INTERFACE)
            target_link_libraries(yaml-cpp INTERFACE -lyaml-cpp)
            message(STATUS "yaml-cpp: fallback -lyaml-cpp")
        endif()
    endif()
else()
    message(STATUS "Found yaml-cpp: ${yaml-cpp_VERSION}")
endif()

# ============================================================================
# 10. OpenCV  (/opt/apollo/sysroot)
# Mirrors: third_party/opencv/opencv.BUILD
# ============================================================================
set(OpenCV_DIR "${APOLLO_SYSROOT}/lib/cmake/opencv4" CACHE PATH "")
find_package(OpenCV QUIET)
if(OpenCV_FOUND)
    message(STATUS "Found OpenCV: ${OpenCV_VERSION}")
else()
    message(STATUS "OpenCV not found (some modules may not build)")
endif()

# ============================================================================
# 11. PCL  (/opt/apollo/sysroot)
# Mirrors: third_party/pcl/pcl_configure.bzl
# ============================================================================
find_package(PCL QUIET PATHS ${APOLLO_SYSROOT}/lib/cmake ${APOLLO_SYSROOT}/share)
if(PCL_FOUND)
    message(STATUS "Found PCL: ${PCL_VERSION}")
    # Create a unified 'pcl' target wrapping find_package results
    add_library(pcl INTERFACE)
    # PCL_INCLUDE_DIRS may be empty with some CMake configs, use known path
    if(PCL_INCLUDE_DIRS)
        target_include_directories(pcl INTERFACE ${PCL_INCLUDE_DIRS})
    else()
        target_include_directories(pcl INTERFACE ${APOLLO_SYSROOT}/include/pcl-1.10)
    endif()
    target_link_directories(pcl INTERFACE ${APOLLO_SYSROOT}/lib)
    target_link_libraries(pcl INTERFACE ${PCL_LIBRARIES})
else()
    if(EXISTS "${APOLLO_SYSROOT}/lib/libpcl_common.so")
        add_library(pcl INTERFACE)
        target_include_directories(pcl INTERFACE ${APOLLO_SYSROOT}/include/pcl-1.10)
        target_link_directories(pcl INTERFACE ${APOLLO_SYSROOT}/lib)
        target_link_libraries(pcl INTERFACE
            -lpcl_common -lpcl_features -lpcl_filters -lpcl_io -lpcl_io_ply
            -lpcl_kdtree -lpcl_octree -lpcl_registration -lpcl_sample_consensus
            -lpcl_search -lpcl_segmentation -lpcl_surface -lpcl_visualization
            Boost::boost
        )
        message(STATUS "PCL: manual config at ${APOLLO_SYSROOT}")
    else()
        message(STATUS "PCL not found")
    endif()
endif()

# ============================================================================
# 12. uuid  (/usr/include/uuid)
# Mirrors: third_party/uuid/uuid.BUILD  → -luuid
# ============================================================================
add_library(uuid INTERFACE)
target_include_directories(uuid INTERFACE /usr/include)
target_link_libraries(uuid INTERFACE -luuid)

# ============================================================================
# 13. tinyxml2  (/usr/include)
# Mirrors: third_party/tinyxml2/tinyxml2.BUILD  → -ltinyxml2
# ============================================================================
add_library(tinyxml2 INTERFACE)
target_include_directories(tinyxml2 INTERFACE /usr/include)
target_link_libraries(tinyxml2 INTERFACE -ltinyxml2)
add_library(tinyxml2::tinyxml2 ALIAS tinyxml2)

# ============================================================================
# 14. Abseil  (/opt/apollo/absl)
# Mirrors: third_party/absl/absl.BUILD
# ============================================================================
if(EXISTS "/opt/apollo/absl/lib")
    add_library(absl INTERFACE)
    target_include_directories(absl INTERFACE /opt/apollo/absl/include)
    target_link_directories(absl INTERFACE /opt/apollo/absl/lib)
    file(GLOB _absl_libs "/opt/apollo/absl/lib/*.so")
    target_link_libraries(absl INTERFACE ${_absl_libs})
    message(STATUS "absl: /opt/apollo/absl")
else()
    find_package(absl QUIET)
    if(absl_FOUND)
        message(STATUS "Found absl: ${absl_VERSION}")
    else()
        message(STATUS "absl not found")
    endif()
endif()

# ============================================================================
# 15. OSQP
# Mirrors: third_party/osqp/osqp.BUILD  → -losqp
# ============================================================================
add_library(osqp INTERFACE)
target_include_directories(osqp INTERFACE ${APOLLO_SYSROOT}/include)
target_link_directories(osqp INTERFACE ${APOLLO_SYSROOT}/lib)
target_link_libraries(osqp INTERFACE -losqp)

# ============================================================================
# 16. SQLite3
# Mirrors: third_party/sqlite3/sqlite3.BUILD  → -lsqlite3
# ============================================================================
add_library(sqlite3 INTERFACE)
target_include_directories(sqlite3 INTERFACE /usr/include)
target_link_libraries(sqlite3 INTERFACE -lsqlite3)

# ============================================================================
# 17. ncurses
# ============================================================================
find_package(Curses QUIET)
if(CURSES_FOUND)
    message(STATUS "Found ncurses: ${CURSES_LIBRARIES}")
endif()

# ============================================================================
# 18. OpenSSL
# ============================================================================
find_package(OpenSSL QUIET)
if(OPENSSL_FOUND)
    message(STATUS "Found OpenSSL: ${OPENSSL_VERSION}")
endif()

# ============================================================================
# 19. civetweb
# ============================================================================
add_library(civetweb INTERFACE)
target_include_directories(civetweb INTERFACE
    ${APOLLO_SYSROOT}/include
    ${CMAKE_SOURCE_DIR}/thirdparty/install/include
    ${CMAKE_SOURCE_DIR}/thirdparty/civetweb-1.11/include
)
target_link_directories(civetweb INTERFACE
    ${APOLLO_SYSROOT}/lib
    ${CMAKE_SOURCE_DIR}/thirdparty/install/lib
)
target_link_libraries(civetweb INTERFACE -lcivetweb -lcivetweb-cpp)

# ============================================================================
# 20. IPOPT
# ============================================================================
add_library(ipopt INTERFACE)
target_include_directories(ipopt INTERFACE ${APOLLO_SYSROOT}/include)
target_link_directories(ipopt INTERFACE ${APOLLO_SYSROOT}/lib)
target_link_libraries(ipopt INTERFACE -lipopt)

# ============================================================================
# 21. proj
# ============================================================================
add_library(proj_lib INTERFACE)
target_include_directories(proj_lib INTERFACE ${APOLLO_SYSROOT}/include)
target_link_directories(proj_lib INTERFACE ${APOLLO_SYSROOT}/lib)
target_link_libraries(proj_lib INTERFACE -lproj)

# ============================================================================
# 22. FFmpeg
# ============================================================================
add_library(ffmpeg INTERFACE)
target_include_directories(ffmpeg INTERFACE ${APOLLO_SYSROOT}/include)
target_link_directories(ffmpeg INTERFACE ${APOLLO_SYSROOT}/lib)
target_link_libraries(ffmpeg INTERFACE -lavcodec -lavformat -lavutil -lswscale -lswresample)

# ============================================================================
# 23. FFTW3
# ============================================================================
add_library(fftw3 INTERFACE)
target_link_libraries(fftw3 INTERFACE -lfftw3)

# ============================================================================
# 24. PortAudio
# ============================================================================
add_library(portaudio INTERFACE)
target_link_libraries(portaudio INTERFACE -lportaudio)

# ============================================================================
# 25. OpenGL / GLEW
# ============================================================================
find_package(OpenGL QUIET)
find_package(GLEW QUIET)

# ============================================================================
# 26. Qt5
# ============================================================================
find_package(Qt5 QUIET COMPONENTS Core Widgets Gui Network)
if(Qt5_FOUND)
    message(STATUS "Found Qt5: ${Qt5_VERSION}")
endif()

# ============================================================================
# 27. VTK
# ============================================================================
find_package(VTK QUIET PATHS ${APOLLO_SYSROOT}/lib/cmake/vtk-8.2)
if(VTK_FOUND)
    message(STATUS "Found VTK: ${VTK_VERSION}")
endif()

# ============================================================================
# 28. libtorch
# ============================================================================
find_package(Torch QUIET)
if(Torch_FOUND)
    message(STATUS "Found Torch: ${Torch_VERSION}")
endif()

# ============================================================================
# 29. OpenH264
# ============================================================================
add_library(openh264 INTERFACE)
target_link_libraries(openh264 INTERFACE -lopenh264)

# ============================================================================
# 30. bvar (brpc, used by cyber/node and cyber/statistics)
# ============================================================================
add_library(bvar INTERFACE)
target_include_directories(bvar INTERFACE /usr/local/include)
target_link_libraries(bvar INTERFACE /usr/local/lib/libbvar.so)

# ============================================================================
# 31. gperftools (used by mainboard: -lprofiler -ltcmalloc)
# ============================================================================
add_library(gperftools INTERFACE)
target_link_libraries(gperftools INTERFACE -lprofiler -ltcmalloc)

# ============================================================================
# 32. ad_rss_lib
# ============================================================================
add_library(ad_rss INTERFACE)
target_include_directories(ad_rss INTERFACE ${APOLLO_SYSROOT}/include)
target_link_directories(ad_rss INTERFACE ${APOLLO_SYSROOT}/lib)

# ============================================================================
# 33. tf2  (/apollo/third_party/tf2 or /opt/apollo/sysroot)
# Mirrors: third_party/tf2/tf2.BUILD
# ============================================================================
if(EXISTS "${CMAKE_SOURCE_DIR}/third_party/tf2")
    add_library(tf2 INTERFACE)
    target_include_directories(tf2 INTERFACE ${CMAKE_SOURCE_DIR}/third_party/tf2/include)
    if(EXISTS "${CMAKE_SOURCE_DIR}/third_party/tf2/lib/libtf2.so")
        target_link_libraries(tf2 INTERFACE ${CMAKE_SOURCE_DIR}/third_party/tf2/lib/libtf2.so)
    else()
        # tf2 might be header-only or built alongside
        file(GLOB _tf2_srcs "${CMAKE_SOURCE_DIR}/third_party/tf2/src/*.cpp")
        if(_tf2_srcs)
            add_library(tf2_impl STATIC ${_tf2_srcs})
            target_include_directories(tf2_impl PUBLIC ${CMAKE_SOURCE_DIR}/third_party/tf2/include)
            target_link_libraries(tf2_impl PUBLIC Boost::headers)
            target_link_libraries(tf2 INTERFACE tf2_impl)
        endif()
    endif()
    message(STATUS "tf2: ${CMAKE_SOURCE_DIR}/third_party/tf2")
elseif(EXISTS "${APOLLO_SYSROOT}/include/tf2")
    add_library(tf2 INTERFACE)
    target_include_directories(tf2 INTERFACE ${APOLLO_SYSROOT}/include)
    target_link_directories(tf2 INTERFACE ${APOLLO_SYSROOT}/lib)
    target_link_libraries(tf2 INTERFACE -ltf2)
    message(STATUS "tf2: ${APOLLO_SYSROOT}")
else()
    add_library(tf2 INTERFACE)
    message(STATUS "tf2: not found (using stub)")
endif()

# ============================================================================
# 34. gRPC  (for map/datachecker, v2x, etc.)
# Mirrors: third_party/grpc
# ============================================================================
find_program(GRPC_CPP_PLUGIN grpc_cpp_plugin
    PATHS /usr/local/bin /usr/bin
          /opt/apollo/sysroot/bin
)
# Also search Bazel cache if not found
if(NOT GRPC_CPP_PLUGIN)
    file(GLOB_RECURSE _bazel_grpc_plugin
        "${CMAKE_SOURCE_DIR}/.cache/bazel/*/execroot/*/bazel-out/host/bin/external/com_github_grpc_grpc/src/compiler/grpc_cpp_plugin"
    )
    if(_bazel_grpc_plugin)
        list(GET _bazel_grpc_plugin 0 GRPC_CPP_PLUGIN)
    endif()
endif()
find_library(GRPC_LIB grpc++ PATHS
    ${CMAKE_SOURCE_DIR}/thirdparty/install/lib
    /usr/local/lib
    /usr/lib/x86_64-linux-gnu)
# Find gRPC include directory
set(GRPC_INCLUDE_DIR "")
foreach(_grpc_inc /apollo/thirdparty/grpc-1.30.0/include /usr/local/include)
    if(EXISTS "${_grpc_inc}/grpc/grpc.h")
        set(GRPC_INCLUDE_DIR "${_grpc_inc}")
        break()
    endif()
endforeach()
# Prefer the fat static archive that bundles all gRPC C/C++ core components
set(GRPC_ALL_LIB "${CMAKE_SOURCE_DIR}/thirdparty/install/lib/libgrpc_all.a")
add_library(grpc++ INTERFACE)
if(GRPC_INCLUDE_DIR)
    target_include_directories(grpc++ INTERFACE ${GRPC_INCLUDE_DIR})
endif()
if(EXISTS "${GRPC_ALL_LIB}")
    set(_GRPC_LIB_DIR "${CMAKE_SOURCE_DIR}/thirdparty/install/lib/grpc")
    if(IS_DIRECTORY "${_GRPC_LIB_DIR}")
        file(GLOB _GRPC_ALL_LIBS "${_GRPC_LIB_DIR}/*.a")
        message(STATUS "gRPC: using ${_GRPC_LIB_DIR}")
        target_link_libraries(grpc++ INTERFACE
            -Wl,--whole-archive
            ${_GRPC_ALL_LIBS}
            -Wl,--no-whole-archive
            -lz -lpthread -lrt -ldl)
    else()
        message(STATUS "gRPC: using fat archive ${GRPC_ALL_LIB}")
        target_link_libraries(grpc++ INTERFACE
            -Wl,--start-group
            ${GRPC_ALL_LIB}
            ${CMAKE_SOURCE_DIR}/thirdparty/install/lib/libboringssl_ssl.a
            ${CMAKE_SOURCE_DIR}/thirdparty/install/lib/libboringssl_crypto.a
            ${CMAKE_SOURCE_DIR}/thirdparty/install/lib/libcares.a
            -Wl,--end-group
            -lz -lpthread -lrt -ldl)
    endif()
elseif(GRPC_LIB)
    message(STATUS "gRPC: using system ${GRPC_LIB}")
    target_link_libraries(grpc++ INTERFACE ${GRPC_LIB} -lgrpc -lgpr -laddress_sorting -lssl -lcrypto -lz -lpthread)
else()
    # grpc libs not installed - header-only mode
    message(STATUS "gRPC: header-only (no system libs found)")
endif()
# Create imported target for grpc_cpp_plugin
if(GRPC_CPP_PLUGIN)
    add_executable(grpc_cpp_plugin IMPORTED)
    set_target_properties(grpc_cpp_plugin PROPERTIES IMPORTED_LOCATION ${GRPC_CPP_PLUGIN})
    message(STATUS "gRPC plugin: ${GRPC_CPP_PLUGIN}")
else()
    message(WARNING "grpc_cpp_plugin not found – gRPC code generation will be skipped")
endif()
if(GRPC_LIB)
    message(STATUS "gRPC: ${GRPC_LIB}")
endif()

# ============================================================================
# 35. hermes_can  (CAN card library)
# Mirrors: third_party/can_card_library/hermes_can
# ============================================================================
add_library(hermes_can INTERFACE)
if(EXISTS "${CMAKE_SOURCE_DIR}/third_party/can_card_library/hermes_can")
    target_include_directories(hermes_can INTERFACE
        ${CMAKE_SOURCE_DIR}/third_party/can_card_library/hermes_can/include)
    # Architecture-specific lib directory
    if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
        set(_hermes_lib_dir "${CMAKE_SOURCE_DIR}/third_party/can_card_library/hermes_can/lib_x86_64")
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64")
        set(_hermes_lib_dir "${CMAKE_SOURCE_DIR}/third_party/can_card_library/hermes_can/lib_aarch64")
    else()
        set(_hermes_lib_dir "${CMAKE_SOURCE_DIR}/third_party/can_card_library/hermes_can/lib")
    endif()
    if(EXISTS "${_hermes_lib_dir}")
        target_link_directories(hermes_can INTERFACE ${_hermes_lib_dir})
        target_link_libraries(hermes_can INTERFACE -lbcan)
    endif()
endif()

# ============================================================================
# 36. ADOLC  (automatic differentiation)
# Mirrors: third_party/adolc
# ============================================================================
add_library(adolc INTERFACE)
if(EXISTS "${APOLLO_SYSROOT}/include/adolc")
    target_include_directories(adolc INTERFACE ${APOLLO_SYSROOT}/include)
    target_link_directories(adolc INTERFACE ${APOLLO_SYSROOT}/lib)
    target_link_libraries(adolc INTERFACE -ladolc)
    message(STATUS "ADOLC: ${APOLLO_SYSROOT}")
else()
    message(STATUS "ADOLC: not found")
endif()

# ============================================================================
# GPU-specific dependencies (conditional)
# ============================================================================
if(APOLLO_USE_GPU)
    enable_language(CUDA)
    find_package(CUDA REQUIRED)

    if(EXISTS "/usr/include/NvInfer.h")
        add_library(tensorrt INTERFACE)
        target_link_libraries(tensorrt INTERFACE -lnvinfer -lnvonnxparser -lnvparsers)
        message(STATUS "Found TensorRT")
    endif()

    find_library(CUDNN_LIBRARY cudnn PATHS ${CUDA_TOOLKIT_ROOT_DIR}/lib64)
    if(CUDNN_LIBRARY)
        add_library(cudnn INTERFACE)
        target_link_libraries(cudnn INTERFACE ${CUDNN_LIBRARY})
        message(STATUS "Found cuDNN: ${CUDNN_LIBRARY}")
    endif()

    if(EXISTS "${APOLLO_SYSROOT}/include/paddle")
        add_library(paddle_inference INTERFACE)
        target_include_directories(paddle_inference INTERFACE ${APOLLO_SYSROOT}/include)
        target_link_directories(paddle_inference INTERFACE ${APOLLO_SYSROOT}/lib)
        target_link_libraries(paddle_inference INTERFACE -lpaddle_inference)
        message(STATUS "Found PaddleInference")
    endif()

    add_library(npp INTERFACE)
    target_link_libraries(npp INTERFACE -lnppc -lnppig -lnppial -lnppist -lnppidei)

    add_library(nvjpeg INTERFACE)
    target_link_libraries(nvjpeg INTERFACE -lnvjpeg)
endif()

# ============================================================================
# 38. localization_msf (third-party closed-source localization library)
# ============================================================================
set(_LOC_MSF_DIR "${CMAKE_SOURCE_DIR}/thirdparty/localization_msf/x86_64")
if(EXISTS "${_LOC_MSF_DIR}")
    add_library(localization_msf_lib INTERFACE)
    target_include_directories(localization_msf_lib INTERFACE ${_LOC_MSF_DIR}/include)
    if(EXISTS "${_LOC_MSF_DIR}/lib")
        target_link_directories(localization_msf_lib INTERFACE ${_LOC_MSF_DIR}/lib)
    endif()
    message(STATUS "localization_msf: ${_LOC_MSF_DIR}")
else()
    add_library(localization_msf_lib INTERFACE)
    message(STATUS "localization_msf: not found")
endif()

