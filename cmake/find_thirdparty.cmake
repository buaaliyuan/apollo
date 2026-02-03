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

#使用pc文件导入第三方库
find_package(PkgConfig REQUIRED)
pkg_check_modules(UUID_LIB REQUIRED IMPORTED_TARGET uuid)
pkg_check_modules(TINYXML2_LIB REQUIRED IMPORTED_TARGET tinyxml2)
pkg_check_modules(PYTHON3.6_LIB REQUIRED IMPORTED_TARGET python-3.6)
pkg_check_modules(TCMALLOC_LIB REQUIRED IMPORTED_TARGET libtcmalloc)
pkg_check_modules(PROFILER_LIB REQUIRED IMPORTED_TARGET libprofiler)
pkg_check_modules(NCURSES_LIB REQUIRED IMPORTED_TARGET ncurses)
pkg_check_modules(SQLITE3_LIB REQUIRED IMPORTED_TARGET sqlite3)


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

# yaml-cpp需要手动安装
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

