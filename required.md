1. 把整个项目从bazel编译改造成cmake方式
2. 改造时参考bazel BUILD文件里面内容、文件和目标定义
3. 第三方库定义参考third_party目录下的定义、WORKSAPCE、docker/build/installers下的文件
4. 第三方库的定义整合到一个cmake文件中去管理，如果系统没有安装需要手动下载源码安装，整理到scripts/install_thirdparty.sh
5. 操作时严格按照BUILD文件的定义进行改造
6. 我的开发使用的docker容器，如果想进入容器调试可以执行./docker/scripts/dev_into.sh命令进入容器，整个工程挂载到了容器的/apollo目录下，使用liyuan账户，编译目录是cmake_build
7. 我是用的是cuda，nvidia显卡
8. protobuf的proto文件需要在cmake中生成pb.cc和pb.h
9. 要支持cpu和gpu两种模式编译
10. cmake 构建时使用15个cpu核心