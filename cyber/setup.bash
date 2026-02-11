#! /usr/bin/env bash
TOP_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd -P)"
source ${TOP_DIR}/scripts/apollo.bashrc

export APOLLO_BAZEL_DIST_DIR="${APOLLO_CACHE_DIR}/distdir"
export CYBER_PATH="${APOLLO_ROOT_DIR}/cyber"

# bazel_bin_path="${APOLLO_ROOT_DIR}/bazel-bin"
bazel_bin_path="${APOLLO_ROOT_DIR}" # 修改工具目录
mainboard_path="${bazel_bin_path}/cyber/mainboard"
cyber_tool_path="${bazel_bin_path}/cyber/tools"
performance_path="${cyber_tool_path}/cyber_performance"
recorder_path="${cyber_tool_path}/cyber_recorder"
launch_path="${cyber_tool_path}/cyber_launch"
channel_path="${cyber_tool_path}/cyber_channel"
node_path="${cyber_tool_path}/cyber_node"
service_path="${cyber_tool_path}/cyber_service"
monitor_path="${cyber_tool_path}/cyber_monitor"
visualizer_path="${bazel_bin_path}/modules/tools/visualizer"

# TODO(all): place all these in one place and pathprepend
for entry in "${mainboard_path}" \
    "${recorder_path}" "${monitor_path}"  \
    "${channel_path}" "${node_path}" \
    "${service_path}" "${performance_path}" \
    "${launch_path}" \
    "${visualizer_path}" ; do
    pathprepend "${entry}"
done

pathprepend ${bazel_bin_path}/cyber/python/internal PYTHONPATH
pathprepend "${PYTHON_INSTALL_PATH}/lib/python${PYTHON_VERSION}/site-packages" PYTHONPATH
pathprepend "${PYTHON_INSTALL_PATH}/bin/" PATH

# 为了运行时能够找到cyber库
pathprepend ${APOLLO_ROOT_DIR}/lib LD_LIBRARY_PATH
pathprepend /apollo/thirdparty/paddleinference/paddle/lib LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/apollo/thirdparty/paddleinference/third_party/install/mklml/lib:/apollo/thirdparty/paddleinference/third_party/install/mkldnn/lib:$LD_LIBRARY_PATH

# 为了python工具能够找到cyber的python包
pathprepend ${APOLLO_ROOT_DIR} PYTHONPATH
pathprepend ${APOLLO_ROOT_DIR}/cyber/examples PATH

export CYBER_DOMAIN_ID=80
export CYBER_IP=127.0.0.1

export GLOG_log_dir="${APOLLO_ROOT_DIR}/data/log"
export GLOG_alsologtostderr=0
export GLOG_colorlogtostderr=1
export GLOG_minloglevel=0

export sysmo_start=0

# for DEBUG log
#export GLOG_v=4

source ${CYBER_PATH}/tools/cyber_tools_auto_complete.bash
