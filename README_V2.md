
## 编译方法
1. 启动docker环境
   1. ./docker/scripts/dev_start.sh
2. 进入docker环境
   1. ./docker/scripts/dev_into.sh
3. 安装第三方库，安装为/apollo/thirdparty目录
   1. /apollo/scripts/install_thirdparty.sh
4. 编译(进入docker环境)
   1. mkdir build;cd build;cmake -DCMAKE_INSTALL_PREFIX=/apollo/output -DAPOLLO_USE_GPU=ON ..;make -j15;make install
5. 编译产物
   1. 编译产物集中生成在/apollo/output


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