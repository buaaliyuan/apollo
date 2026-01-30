# cmake/toolchains/j6_platform.cmake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# 设置交叉编译器路径（通常是 J6 SDK 提供的）
set(TOOLCHAIN_HOME /opt/hobot/gcc-ubuntu-9.4.0-aarch64-linux-gnu)
set(CMAKE_C_COMPILER ${TOOLCHAIN_HOME}/bin/aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_HOME}/bin/aarch64-linux-gnu-g++)

# 这里的路径非常重要，决定了寻找库的根目录
set(CMAKE_FIND_ROOT_PATH  ${TOOLCHAIN_HOME} /path/to/j6/sdk/sysroot)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)