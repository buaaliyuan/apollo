# ============================================================================
# modules/perception/msg_adapter/CMakeLists.txt
# Component: libmsg_adapter_component.so
# ============================================================================

# ── Main library ──
set(_ma_gpu_deps)
if(APOLLO_USE_GPU)
    list(APPEND _ma_gpu_deps ${CUDA_LIBRARIES} ${CUDA_CUBLAS_LIBRARIES})
    if(TARGET tensorrt)
        list(APPEND _ma_gpu_deps tensorrt)
    endif()
    if(TARGET cudnn)
        list(APPEND _ma_gpu_deps cudnn)
    endif()
endif()

apollo_cc_library(
    NAME apollo_perception_msg_adapter
    SRCS
        common/msg_adapter_gflags.cc
    HDRS
        common/msg_adapter_gflags.h
        convert/common.h
        convert/convert.h
        msg_converter.h
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_onboard
        perception_obstacle_cc_proto
        gflags
        ${_ma_gpu_deps}
    COPTS -DMODULE_NAME="perception"
)

if(APOLLO_USE_GPU)
    target_include_directories(apollo_perception_msg_adapter PUBLIC ${CUDA_INCLUDE_DIRS})
endif()

# ── Component .so ──
apollo_component(
    NAME libmsg_adapter_component.so
    SRCS msg_adapter_component.cc
    HDRS msg_adapter_component.h
    DEPS
        apollo_perception_msg_adapter
        cyber
    COPTS -DMODULE_NAME="perception"
)
