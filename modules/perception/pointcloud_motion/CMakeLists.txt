# ============================================================================
# modules/perception/pointcloud_motion/CMakeLists.txt
# Component: libpointcloud_motion_component.so
# Requires GPU (CUDA for pointwise_unet)
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _pm_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_pm_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_pointcloud_motion_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_pm_proto_deps)
foreach(_proto ${_pm_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _pm_proto_deps "perception_pointcloud_motion_${_rs}_cc_proto")
endforeach()

# ── Main library ──
file(GLOB_RECURSE _pm_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER _pm_srcs EXCLUDE REGEX ".*_test\\.cc$")
list(FILTER _pm_srcs EXCLUDE REGEX ".*_component\\.cc$")

if(NOT APOLLO_USE_GPU)
    list(FILTER _pm_srcs EXCLUDE REGEX ".*/pointwise_unet/.*\\.cc$")
endif()

set(_pm_gpu_deps)
if(APOLLO_USE_GPU)
    list(APPEND _pm_gpu_deps ${CUDA_LIBRARIES})
endif()

if(_pm_srcs)
    apollo_cc_library(
        NAME apollo_perception_pointcloud_motion
        SRCS ${_pm_srcs}
        DEPS
            cyber
            apollo_perception_common_base
            apollo_perception_common_algorithm
            apollo_perception_common_inference
            apollo_perception_common_lib
            apollo_perception_common_lidar
            ${_pm_proto_deps}
            pcl
            ${_pm_gpu_deps}
        COPTS -DMODULE_NAME="perception"
    )
else()
    apollo_cc_library(
        NAME apollo_perception_pointcloud_motion
        INTERFACE
        DEPS cyber apollo_perception_common_lidar
    )
endif()

# ── Component .so ──
apollo_component(
    NAME libpointcloud_motion_component.so
    SRCS pointcloud_motion_component.cc
    HDRS pointcloud_motion_component.h
    DEPS
        apollo_perception_pointcloud_motion
        cyber
        apollo_perception_common_lidar
        apollo_perception_common_onboard
        ${_pm_proto_deps}
        Boost::headers
    COPTS -DMODULE_NAME="perception"
    LINKOPTS -lleveldb
)
