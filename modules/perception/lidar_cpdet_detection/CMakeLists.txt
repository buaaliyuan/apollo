# ============================================================================
# modules/perception/lidar_cpdet_detection/CMakeLists.txt
# Component: liblidar_cpdet_detection_component.so
# Requires GPU
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _lcd_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_lcd_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_lidar_cpdet_detection_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_lcd_proto_deps)
foreach(_proto ${_lcd_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _lcd_proto_deps "perception_lidar_cpdet_detection_${_rs}_cc_proto")
endforeach()

# ── Main library (GPU-dependent) ──
file(GLOB_RECURSE _lcd_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER _lcd_srcs EXCLUDE REGEX ".*_test\\.cc$")
list(FILTER _lcd_srcs EXCLUDE REGEX ".*_component\\.cc$")

if(NOT APOLLO_USE_GPU)
    list(FILTER _lcd_srcs EXCLUDE REGEX ".*/detector/cpdet/.*\\.cc$")
endif()

set(_lcd_gpu_deps)
if(APOLLO_USE_GPU)
    list(APPEND _lcd_gpu_deps ${CUDA_LIBRARIES})
    if(TARGET tensorrt)
        list(APPEND _lcd_gpu_deps tensorrt)
    endif()
    if(Torch_FOUND)
        list(APPEND _lcd_gpu_deps ${TORCH_LIBRARIES})
    endif()
endif()

if(_lcd_srcs)
    apollo_cc_library(
        NAME apollo_perception_lidar_cpdetection
        SRCS ${_lcd_srcs}
        DEPS
            cyber
            apollo_perception_common_base
            apollo_perception_common_algorithm
            apollo_perception_common_inference
            apollo_perception_common_lib
            apollo_perception_common_lidar
            apollo_perception_common_onboard
            apollo_perception_common_interface
            perception_gflags
            perception_common_util
            perception_perception_config_schema_cc_proto
            ${_lcd_proto_deps}
            absl
            eigen
            pcl
            ${_lcd_gpu_deps}
        COPTS -DMODULE_NAME="perception"
    )
else()
    apollo_cc_library(
        NAME apollo_perception_lidar_cpdetection
        INTERFACE
        DEPS cyber apollo_perception_common_onboard
    )
endif()

# ── Component .so ──
apollo_component(
    NAME liblidar_cpdet_detection_component.so
    SRCS lidar_cpdetection_component.cc
    HDRS lidar_cpdetection_component.h
    DEPS
        apollo_perception_lidar_cpdetection
        cyber
        apollo_perception_common_onboard
        ${_lcd_proto_deps}
    COPTS -DMODULE_NAME="perception"
    LINKOPTS -lleveldb
)
