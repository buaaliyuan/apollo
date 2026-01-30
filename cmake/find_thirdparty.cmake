find_package(fastrtps REQUIRED)
find_package(fastcdr REQUIRED)
find_package(glog REQUIRED)
find_package(Protobuf REQUIRED)
find_package(Boost REQUIRED COMPONENTS filesystem)
find_package(gflags REQUIRED COMPONENTS shared)
find_package(absl REQUIRED ) #todo:docker中的absl是采用14版本编译的和future.h冲突，后续需要替换掉
find_package(Eigen3 REQUIRED)

find_package(osqp REQUIRED)
#/apollo/modules/common/math/mpc_osqp.h needs to add sysroot include path
get_target_property(osqp_includes osqp::osqp INTERFACE_INCLUDE_DIRECTORIES)
set_target_properties(osqp::osqp PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${osqp_includes};/opt/apollo/sysroot/include")


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

FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/releases/download/v1.17.0/googletest-1.17.0.tar.gz
)
FetchContent_MakeAvailable(googletest)

set(JSON_BuildTests OFF CACHE INTERNAL "Whether to build tests for nlohmann_json")
FetchContent_Declare(
    nlohmann
    URL https://github.com/nlohmann/json/archive/v3.8.0.tar.gz
)
FetchContent_MakeAvailable(nlohmann)


add_library(bvar::bvar UNKNOWN IMPORTED)
set_target_properties(bvar::bvar PROPERTIES
    IMPORTED_LOCATION "/usr/local/lib/libbvar.so"
    INTERFACE_INCLUDE_DIRECTORIES "/usr/local/include/third_party/var"
)