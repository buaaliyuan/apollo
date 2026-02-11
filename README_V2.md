
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

## 其他说明
1. make install时，库和配置文件都安装到了/apollo/output。方便后面嵌入式平台打包使用。
2. dag文件配置的config还是使用的源码中的配置路径，需要后面统一切换
3. 关于环境变量
   1. [apollo.bashrc](scripts/apollo.bashrc) 修改了`APOLLO_ROOT_DIR`,`APOLLO_LIB_PATH`,`APOLLO_PLUGIN_LIB_PATH`
   2. [setup.bash](cyber/setup.bash) 修改了`PYTHONPATH`和`LD_LIBRARY_PATH`
4. 

## 启动测试模块记录
- [x] storytelling `cyber_launch.py start /apollo/modules/storytelling/launch/storytelling.launch`
- [ ] v2x 因为grpc的问题暂时屏蔽不编译 