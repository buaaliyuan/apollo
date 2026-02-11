# ============================================================================
# modules/perception/lidar_detection_filter/CMakeLists.txt
# Component: liblidar_detection_filter_component.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _ldf_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_ldf_protos})
    get_filename_component(_proto_name ${_proto} NAME_WE)
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    set(_proto_target "perception_lidar_detection_filter_${_rel_safe}_cc_proto")
    apollo_proto_library(
        NAME ${_proto_target}
        SRCS ${_proto}
        DEPS perception_perception_config_schema_cc_proto
    )
endforeach()

# ── Main library ──
apollo_cc_library(
    NAME apollo_perception_lidar_detection_filter
    SRCS
        object_filter_bank/object_filter_bank.cc
    HDRS
        interface/base_object_filter.h
        object_filter_bank/object_filter_bank.h
    DEPS
        cyber
        perception_common_util
        apollo_perception_common_algorithm
        apollo_perception_common_base
        apollo_perception_common_lib
        apollo_perception_common_lidar
        apollo_perception_common_onboard
        perception_perception_config_schema_cc_proto
        perception_lidar_detection_filter_object_filter_bank_proto_background_filter_config_cc_proto
        perception_lidar_detection_filter_object_filter_bank_proto_strategy_filter_config_cc_proto
        perception_lidar_detection_filter_object_filter_bank_proto_filter_bank_config_cc_proto
        perception_lidar_detection_filter_object_filter_bank_proto_roi_boundary_filter_config_cc_proto
        perception_lidar_detection_filter_proto_lidar_detection_filter_component_config_cc_proto
        eigen
        pcl
    COPTS -DMODULE_NAME="perception"
)

# ── Component .so ──
apollo_component(
    NAME liblidar_detection_filter_component.so
    SRCS lidar_detection_filter_component.cc
    HDRS lidar_detection_filter_component.h
    DEPS
        apollo_perception_lidar_detection_filter
        cyber
        apollo_perception_common_onboard
        perception_lidar_detection_filter_proto_lidar_detection_filter_component_config_cc_proto
    COPTS -DMODULE_NAME="perception"
)
