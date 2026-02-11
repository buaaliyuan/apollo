# ============================================================================
# modules/perception/pointcloud_ground_detection/CMakeLists.txt
# Component: libpointcloud_ground_detection_component.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _pgd_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_pgd_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_pointcloud_ground_detection_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_pgd_proto_deps)
foreach(_proto ${_pgd_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _pgd_proto_deps "perception_pointcloud_ground_detection_${_rs}_cc_proto")
endforeach()

# ── Main library ──
apollo_cc_library(
    NAME apollo_perception_pointcloud_ground_detection
    SRCS
        ground_detector/ground_service_detector/ground_service_detector.cc
        ground_detector/spatio_temporal_ground_detector/spatio_temporal_ground_detector.cc
    HDRS
        ground_detector/ground_service_detector/ground_service_detector.h
        ground_detector/spatio_temporal_ground_detector/spatio_temporal_ground_detector.h
        interface/base_ground_detector.h
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        apollo_perception_common_lib
        apollo_perception_common_lidar
        apollo_perception_common_onboard
        perception_common_util
        perception_perception_config_schema_cc_proto
        ${_pgd_proto_deps}
        eigen
    COPTS -DMODULE_NAME="perception" -msse4.1
)

# ── Component .so ──
apollo_component(
    NAME libpointcloud_ground_detection_component.so
    SRCS pointcloud_ground_detection_component.cc
    HDRS pointcloud_ground_detection_component.h
    DEPS
        apollo_perception_pointcloud_ground_detection
        cyber
        apollo_perception_common_onboard
        ${_pgd_proto_deps}
    COPTS -DMODULE_NAME="perception"
    LINKOPTS -lleveldb
)
