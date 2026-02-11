# ============================================================================
# modules/perception/radar4d_detection/CMakeLists.txt
# Component: libradar4d_detection.so
# Requires GPU for point_pillars CUDA kernels
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _r4d_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_r4d_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_radar4d_detection_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_r4d_proto_deps)
foreach(_proto ${_r4d_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _r4d_proto_deps "perception_radar4d_detection_${_rs}_cc_proto")
endforeach()

# ── Main library ──
file(GLOB_RECURSE _r4d_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER _r4d_srcs EXCLUDE REGEX ".*_test\\.cc$")
list(FILTER _r4d_srcs EXCLUDE REGEX ".*_component\\.cc$")

if(NOT APOLLO_USE_GPU)
    list(FILTER _r4d_srcs EXCLUDE REGEX ".*/point_pillars.*\\.cc$")
    list(FILTER _r4d_srcs EXCLUDE REGEX ".*/semantic_map/evaluator_manager\\.cc$")
endif()

set(_r4d_gpu_deps)
if(APOLLO_USE_GPU)
    list(APPEND _r4d_gpu_deps ${CUDA_LIBRARIES})
    if(TARGET tensorrt)
        list(APPEND _r4d_gpu_deps tensorrt)
    endif()
    if(Torch_FOUND)
        list(APPEND _r4d_gpu_deps ${TORCH_LIBRARIES})
    endif()
endif()

if(_r4d_srcs)
    apollo_cc_library(
        NAME apollo_perception_radar4d_detection
        SRCS ${_r4d_srcs}
        DEPS
            cyber
            apollo_perception_common_base
            apollo_perception_common_algorithm
            apollo_perception_common_hdmap
            apollo_perception_common_inference
            apollo_perception_common_lib
            apollo_perception_common_onboard
            apollo_perception_common_radar
            perception_gflags
            perception_common_util
            perception_perception_config_schema_cc_proto
            oculii_radar_cc_proto
            ${_r4d_proto_deps}
            absl
            eigen
            pcl
            ${_r4d_gpu_deps}
        COPTS -DMODULE_NAME="perception"
    )
else()
    apollo_cc_library(
        NAME apollo_perception_radar4d_detection
        INTERFACE
        DEPS cyber apollo_perception_common_onboard
    )
endif()

# ── Component .so ──
apollo_component(
    NAME libradar4d_detection.so
    SRCS radar4d_detection_component.cc
    HDRS radar4d_detection_component.h
    DEPS
        apollo_perception_radar4d_detection
        cyber
        apollo_perception_common_algorithm
        apollo_perception_common_base
        apollo_perception_common_hdmap
        apollo_perception_common_lib
        apollo_perception_common_onboard
        ${_r4d_proto_deps}
    COPTS -DMODULE_NAME="perception"
    LINKOPTS -lleveldb
)
