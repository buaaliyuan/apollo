## 第三方库安装
1. ./scripts/install_thirdparty.sh
   1. install_thirdparty.sh脚本提取了apollo项目下WORKSPACE和third_party下的bazel定义的内容
   2. 安装完成后生成thirdparty路径
   
## 编译方法
1. 启动docker环境
   1. ./docker/scripts/dev_start.sh
2. 进入docker环境
   1. ./docker/scripts/dev_into.sh
3. 安装第三方库（x86，根据apollo的third_party中的安装过程生成)
   1. /apollo/scripts/install_thirdparty.sh
4. 编译(进入docker环境)
   1. mkdir build;cd build;cmake ..;make -j10
5. 编译产物
   1. 编译产物集中生成在build下的bin和lib目录下


## 第三方库
1. 第三方库集中在 cmake/ThirdPartyDeps.cmake中导入，后面有变更直接改这里
2. apollo第三方库比较乱
   1. 通过docker build阶段直接编译安装的
   2. 通过docker build阶段apt安装的
   3. 通过bazel编译阶段在线下载的（已经改造到了intall_thirdparty.sh)
   4. 第三方库位置/usr/local、/opt
   5. abseil apollo提前编译好的，但是用的c++标准比较低，如果apollo开启c++17以上会存在问题

## todo
1. 