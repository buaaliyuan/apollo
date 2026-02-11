# ============================================================================
# modules/perception/traffic_light_region_proposal/CMakeLists.txt
# Component: libtraffic_component_proposal.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _tlrp_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_tlrp_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_traffic_light_region_proposal_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_tlrp_proto_deps)
foreach(_proto ${_tlrp_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _tlrp_proto_deps "perception_traffic_light_region_proposal_${_rs}_cc_proto")
endforeach()

# ── Main library ──
apollo_cc_library(
    NAME apollo_perception_traffic_light_region_proposal
    SRCS
        preprocessor/multi_camera_projection.cc
        preprocessor/tl_preprocessor.cc
    HDRS
        interface/base_tl_preprocessor.h
        preprocessor/multi_camera_projection.h
        preprocessor/tl_preprocessor.h
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        apollo_perception_common_camera
        apollo_perception_common_hdmap
        apollo_perception_common_lib
        apollo_perception_common_onboard
        error_code_cc_proto
        geometry_cc_proto
        header_cc_proto
        perception_camera_cc_proto
        perception_lane_cc_proto
        perception_obstacle_cc_proto
        traffic_light_detection_cc_proto
        sensor_image_cc_proto
        transform_cc_proto
        ${_tlrp_proto_deps}
        gflags
        eigen
    COPTS -DMODULE_NAME="trafficlight"
)

# ── Component .so ──
apollo_component(
    NAME libtraffic_component_proposal.so
    SRCS traffic_light_region_proposal_component.cc
    HDRS traffic_light_region_proposal_component.h
    DEPS
        apollo_perception_traffic_light_region_proposal
        cyber
        apollo_perception_common_base
        apollo_perception_common_camera
        apollo_perception_common_hdmap
        apollo_perception_common_onboard
        error_code_cc_proto
        geometry_cc_proto
        header_cc_proto
        perception_camera_cc_proto
        perception_lane_cc_proto
        perception_obstacle_cc_proto
        traffic_light_detection_cc_proto
        sensor_image_cc_proto
        transform_cc_proto
        ${_tlrp_proto_deps}
        eigen
    COPTS -DMODULE_NAME="trafficlight"
    LINKOPTS -lpthread
)
