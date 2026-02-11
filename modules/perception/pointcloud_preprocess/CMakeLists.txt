# ============================================================================
# modules/perception/pointcloud_preprocess/CMakeLists.txt
# Component: libpointcloud_preprocess_component.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _pp_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_pp_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_pointcloud_preprocess_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_pp_proto_deps)
foreach(_proto ${_pp_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _pp_proto_deps "perception_pointcloud_preprocess_${_rs}_cc_proto")
endforeach()

# ── Main library ──
apollo_cc_library(
    NAME apollo_perception_pointcloud_preprocess
    SRCS
        preprocessor/pointcloud_preprocessor.cc
    HDRS
        interface/base_pointcloud_preprocessor.h
        preprocessor/pointcloud_preprocessor.h
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        apollo_perception_common_lib
        apollo_perception_common_lidar
        apollo_perception_common_onboard
        perception_common_util
        pointcloud_cc_proto
        ${_pp_proto_deps}
        eigen
    COPTS -DMODULE_NAME="perception"
)

# ── Component .so ──
apollo_component(
    NAME libpointcloud_preprocess_component.so
    SRCS pointcloud_preprocess_component.cc
    HDRS pointcloud_preprocess_component.h
    DEPS
        apollo_perception_pointcloud_preprocess
        cyber
        apollo_perception_common_algorithm
        apollo_perception_common_lidar
        apollo_perception_common_onboard
        pointcloud_cc_proto
        ${_pp_proto_deps}
    COPTS -DMODULE_NAME="perception"
    LINKOPTS -lleveldb
)
