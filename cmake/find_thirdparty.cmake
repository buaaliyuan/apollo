find_package(fastrtps REQUIRED)
find_package(fastcdr REQUIRED)
find_package(glog REQUIRED)
find_package(Protobuf REQUIRED)
find_package(Boost REQUIRED COMPONENTS filesystem)
find_package(gflags REQUIRED COMPONENTS shared)
find_package(GTest REQUIRED) # 自己安装的/apollo/thirdparty/install
find_package(absl REQUIRED ) #todo:docker中的absl是采用14版本编译的和future.h冲突，后续需要替换掉
find_package(Eigen3 REQUIRED)

find_package(osqp REQUIRED)
#/apollo/modules/common/math/mpc_osqp.h needs to add sysroot include path
get_target_property(osqp_includes osqp::osqp INTERFACE_INCLUDE_DIRECTORIES)
set_target_properties(osqp::osqp PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${osqp_includes};/opt/apollo/sysroot/include")

find_package(ATen REQUIRED)
find_package(Torch REQUIRED)
find_package(yaml-cpp REQUIRED) #自己编译安装在了/opt/apollo/thirdparty/install
find_package(OpenCV REQUIRED) #/opt/apollo/sysroot
find_package(Boost REQUIRED COMPONENTS program_options thread filesystem) #/opt/apollo/sysroot
find_package(PROJ REQUIRED)
find_package(osqp REQUIRED)
find_package(CUDAToolkit REQUIRED)



#使用pc文件导入第三方库
find_package(PkgConfig REQUIRED)
pkg_check_modules(UUID_LIB REQUIRED IMPORTED_TARGET uuid)
pkg_check_modules(TINYXML2_LIB REQUIRED IMPORTED_TARGET tinyxml2)
pkg_check_modules(PYTHON3.6_LIB REQUIRED IMPORTED_TARGET python-3.6)
pkg_check_modules(TCMALLOC_LIB REQUIRED IMPORTED_TARGET libtcmalloc)
pkg_check_modules(PROFILER_LIB REQUIRED IMPORTED_TARGET libprofiler)
pkg_check_modules(NCURSES_LIB REQUIRED IMPORTED_TARGET ncurses)
pkg_check_modules(SQLITE3_LIB REQUIRED IMPORTED_TARGET sqlite3)
pkg_check_modules(IPOPT_LIB REQUIRED IMPORTED_TARGET ipopt)
pkg_check_modules(ADOLC_LIB REQUIRED IMPORTED_TARGET adolc)


# 在线获取第三方库，后面会被替换掉
include(FetchContent)

# FetchContent_Declare(
#     googletest
#     URL https://github.com/google/googletest/releases/download/v1.17.0/googletest-1.17.0.tar.gz
# )
# FetchContent_MakeAvailable(googletest)

set(JSON_BuildTests OFF CACHE INTERNAL "Whether to build tests for nlohmann_json")
FetchContent_Declare(
    nlohmann
    URL https://github.com/nlohmann/json/archive/v3.8.0.tar.gz
)
FetchContent_MakeAvailable(nlohmann)

# yaml-cpp需要手动安装,在/opt/apollo/thirdparty/install目录下
# FetchContent_Declare(
#     yaml-cpp
#     URL https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.3.tar.gz
# )
# set(YAML_CPP_BUILD_TESTS OFF CACHE INTERNAL FORCE "Whether to build tests for yaml-cpp")
# set(YAML_CPP_BUILD_TOOLS OFF CACHE INTERNAL FORCE "Whether to build tools for yaml-cpp")
# set(YAML_BUILD_SHARED_LIBS ON CACHE INTERNAL FORCE "Build yaml-cpp as shared library")
# FetchContent_MakeAvailable(yaml-cpp)

add_library(bvar::bvar UNKNOWN IMPORTED)
set_target_properties(bvar::bvar PROPERTIES
    IMPORTED_LOCATION "/usr/local/lib/libbvar.so"
    INTERFACE_INCLUDE_DIRECTORIES "/usr/local/include/third_party/var"
)

#临时安装到了thirdparty目录下，后续需要集成到apollo的thirdparty管理脚本中
# cmake -DCIVETWEB_ENABLE_WEBSOCKETS=ON -DCIVETWEB_ENABLE_CXX=ON  -DBUILD_SHARED_LIBS=ON  -DCMAKE_INSTALL_PREFIX=/apollo/thirdparty/install/ ..
add_library(civetweb::civetweb UNKNOWN IMPORTED)
set_target_properties(civetweb::civetweb PROPERTIES
    IMPORTED_LOCATION "/apollo/thirdparty/install/lib/libcivetweb.so"
    INTERFACE_INCLUDE_DIRECTORIES "/apollo/thirdparty/install/include"
)


# 把sysroot下的ffmpeg库导入进来
add_library(ffmepg::avcodec SHARED IMPORTED)
set_target_properties(ffmepg::avcodec PROPERTIES
    IMPORTED_LOCATION "/opt/apollo/sysroot/lib/libavcodec.so"
    INTERFACE_INCLUDE_DIRECTORIES "/opt/apollo/sysroot/include"
)
add_library(ffmepg::avformat SHARED IMPORTED)
set_target_properties(ffmepg::avformat PROPERTIES
    IMPORTED_LOCATION "/opt/apollo/sysroot/lib/libavformat.so"
    INTERFACE_INCLUDE_DIRECTORIES "/opt/apollo/sysroot/include"
)
add_library(ffmepg::avutil SHARED IMPORTED)
set_target_properties(ffmepg::avutil PROPERTIES
    IMPORTED_LOCATION "/opt/apollo/sysroot/lib/libavutil.so"
    INTERFACE_INCLUDE_DIRECTORIES "/opt/apollo/sysroot/include"
)
add_library(ffmepg::ffmpeg INTERFACE IMPORTED)
set_target_properties(ffmepg::ffmpeg PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "/opt/apollo/sysroot/include"
    INTERFACE_LINK_LIBRARIES "ffmepg::avcodec;ffmepg::avformat;ffmepg::avutil"
)

# adv_bcan库
add_library(adv_bcan::bcan SHARED IMPORTED)
set_target_properties(adv_bcan::bcan PROPERTIES
    IMPORTED_LOCATION "/opt/apollo/pkgs/adv_plat/lib/libadv_bcan.so"
    INTERFACE_INCLUDE_DIRECTORIES "/opt/apollo/pkgs/adv_plat/include"
)
# adv_trigger库
add_library(adv_bcan::trigger SHARED IMPORTED)
set_target_properties(adv_bcan::trigger PROPERTIES
    IMPORTED_LOCATION "/opt/apollo/pkgs/adv_plat/lib/libadv_trigger.so"
    INTERFACE_INCLUDE_DIRECTORIES "/opt/apollo/pkgs/adv_plat/include"
)
# adv_plat整合目标
add_library(adv_bcan::adv_plat INTERFACE IMPORTED)
set_target_properties(adv_bcan::adv_plat PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "/opt/apollo/pkgs/adv_plat/include"
    INTERFACE_LINK_LIBRARIES "adv_bcan::bcan;adv_bcan::trigger"
)


# 导入PCL
set(PCL_SYSROOT_LIB_DIR "/opt/apollo/sysroot/lib")
set(PCL_SYSROOT_INCLUDE_DIRS "/opt/apollo/sysroot/include" "/opt/apollo/sysroot/include/pcl-1.10")
file(GLOB PCL_SYSROOT_LIBS "${PCL_SYSROOT_LIB_DIR}/libpcl_*.so")

set(PCL_IMPORTED_TARGETS "")
foreach(PCL_LIB_PATH ${PCL_SYSROOT_LIBS})
    get_filename_component(PCL_LIB_NAME_WE ${PCL_LIB_PATH} NAME_WE)
    if(PCL_LIB_NAME_WE MATCHES "^libpcl_")
        string(REPLACE "lib" "" PCL_TARGET_NAME ${PCL_LIB_NAME_WE})
        add_library(pcl::${PCL_TARGET_NAME} SHARED IMPORTED)
        set_target_properties(pcl::${PCL_TARGET_NAME} PROPERTIES
            IMPORTED_LOCATION "${PCL_LIB_PATH}"
            INTERFACE_INCLUDE_DIRECTORIES "${PCL_SYSROOT_INCLUDE_DIRS}"
        )
        list(APPEND PCL_IMPORTED_TARGETS pcl::${PCL_TARGET_NAME})
    endif()
endforeach()

add_library(pcl::pcl INTERFACE IMPORTED)
set_target_properties(pcl::pcl PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${PCL_SYSROOT_INCLUDE_DIRS}"
    INTERFACE_LINK_LIBRARIES "${PCL_IMPORTED_TARGETS}"
)

# 导入localization_msf库
# https://apollo-pkg-beta.bj.bcebos.com/archive/localization_msf-linux-any-1.0.0.tar.gz
# 需要把include里面的文件建一个localization_msf的子目录，然后把头文件放进去
add_library(localization_msf::localization_msf SHARED IMPORTED)
set_target_properties(localization_msf::localization_msf PROPERTIES
    IMPORTED_LOCATION "/apollo/thirdparty/localization_msf/x86_64/lib/liblocalization_msf.so"
    INTERFACE_INCLUDE_DIRECTORIES "/apollo/thirdparty/localization_msf/x86_64/include"
)

add_library(gfortran INTERFACE IMPORTED)
set_target_properties(gfortran PROPERTIES
    INTERFACE_LINK_LIBRARIES "/usr/lib/x86_64-linux-gnu/libgfortran.so.4.0.0"
)


# 导入ad-rss-lib库
# https://github.com/intel/ad-rss-lib/archive/v1.1.0.tar.gz
find_package(ad-rss-lib REQUIRED)
# message(STATUS "=========")
# if(TARGET ad-rss-lib)
#     get_target_property(AD_RSS_INCLUDE_DIRS ad-rss-lib INTERFACE_INCLUDE_DIRECTORIES)
#     message(STATUS "ad-rss-lib INTERFACE_INCLUDE_DIRECTORIES: ${AD_RSS_INCLUDE_DIRS}")
    
#     get_target_property(AD_RSS_LOCATION ad-rss-lib IMPORTED_LOCATION)
#     message(STATUS "ad-rss-lib IMPORTED_LOCATION: ${AD_RSS_LOCATION}")
# endif()
#ad-rss-lib缺少一些头文件，需要把src目录下的头文件也安装进去
# install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src/
#         DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/ad_rss
#         FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp")

add_library(tensorrt::tensorrt INTERFACE IMPORTED)
set_target_properties(tensorrt::tensorrt PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "/usr/include/x86_64-linux-gnu"
    INTERFACE_LINK_LIBRARIES "/usr/lib/x86_64-linux-gnu/libnvinfer.so"
)