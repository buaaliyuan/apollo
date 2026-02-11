# ============================================================================
# modules/perception/lidar_segmentation/CMakeLists.txt
# Component: liblidar_segmentation_component.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _ls_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_ls_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_lidar_segmentation_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

# Collect proto targets
set(_ls_proto_deps)
foreach(_proto ${_ls_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _ls_proto_deps "perception_lidar_segmentation_${_rs}_cc_proto")
endforeach()

# ── Common library ──
file(GLOB _ls_common_srcs common/*.cc)
list(FILTER _ls_common_srcs EXCLUDE REGEX ".*_test\\.cc$")

if(_ls_common_srcs)
    apollo_cc_library(
        NAME lidar_segmentation_common
        SRCS ${_ls_common_srcs}
        DEPS
            cyber
            apollo_perception_common_base
            apollo_perception_common_lidar
            apollo_perception_common_onboard
        COPTS -DMODULE_NAME="perception"
    )
endif()

# ── Segmentor libraries ──
file(GLOB_RECURSE _graph_seg_srcs segmentor/graph_segmentation/*.cc)
list(FILTER _graph_seg_srcs EXCLUDE REGEX ".*_test\\.cc$")
if(_graph_seg_srcs)
    apollo_cc_library(
        NAME graph_segmentation
        SRCS ${_graph_seg_srcs}
        DEPS
            cyber
            apollo_perception_common_base
            apollo_perception_common_algorithm
            apollo_perception_common_lib
            apollo_perception_common_lidar
            ${_ls_proto_deps}
        COPTS -DMODULE_NAME="perception"
    )
endif()

file(GLOB_RECURSE _ncut_seg_srcs segmentor/ncut_segmentation/*.cc)
list(FILTER _ncut_seg_srcs EXCLUDE REGEX ".*_test\\.cc$")
if(_ncut_seg_srcs)
    apollo_cc_library(
        NAME ncut_segmentation
        SRCS ${_ncut_seg_srcs}
        DEPS
            cyber
            apollo_perception_common_base
            apollo_perception_common_algorithm
            apollo_perception_common_lib
            apollo_perception_common_lidar
            ${_ls_proto_deps}
        COPTS -DMODULE_NAME="perception"
    )
endif()

# ── Component .so ──
set(_ls_comp_deps
    cyber
    apollo_perception_common_onboard
    ${_ls_proto_deps}
)
if(TARGET lidar_segmentation_common)
    list(APPEND _ls_comp_deps lidar_segmentation_common)
endif()
if(TARGET graph_segmentation)
    list(APPEND _ls_comp_deps graph_segmentation)
endif()
if(TARGET ncut_segmentation)
    list(APPEND _ls_comp_deps ncut_segmentation)
endif()

apollo_component(
    NAME liblidar_segmentation_component.so
    SRCS lidar_segmentation_component.cc
    HDRS lidar_segmentation_component.h
    DEPS ${_ls_comp_deps}
    COPTS -DMODULE_NAME="perception"
    LINKOPTS -lleveldb
)
