# ============================================================================
# modules/perception/pointcloud_map_based_roi/CMakeLists.txt
# Component: libpointcloud_map_based_roi_component.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _pmr_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_pmr_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_pointcloud_map_based_roi_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_pmr_proto_deps)
foreach(_proto ${_pmr_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _pmr_proto_deps "perception_pointcloud_map_based_roi_${_rs}_cc_proto")
endforeach()

# ── Main library ──
apollo_cc_library(
    NAME apollo_perception_pointcloud_map_based_roi
    SRCS
        map_manager/map_manager.cc
    HDRS
        interface/base_roi_filter.h
        map_manager/map_manager.h
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_hdmap
        apollo_perception_common_lib
        apollo_perception_common_lidar
        apollo_perception_common_onboard
        perception_common_util
        apollo_map
        ${_pmr_proto_deps}
    COPTS -DMODULE_NAME="perception"
)

# ── Component .so ──
apollo_component(
    NAME libpointcloud_map_based_roi_component.so
    SRCS pointcloud_map_based_roi_component.cc
    HDRS pointcloud_map_based_roi_component.h
    DEPS
        apollo_perception_pointcloud_map_based_roi
        cyber
        apollo_perception_common_lidar
        apollo_perception_common_onboard
        ${_pmr_proto_deps}
    COPTS -DMODULE_NAME="perception"
)
