# ============================================================================
# modules/third_party_perception/CMakeLists.txt
# ============================================================================

# ── Proto ──
apollo_proto_library(
    NAME radar_obstacle_cc_proto
    SRCS proto/radar_obstacle.proto
    DEPS
        error_code_cc_proto
        header_cc_proto
        perception_obstacle_cc_proto
        geometry_cc_proto
)

apollo_proto_library(
    NAME third_party_perception_component_cc_proto
    SRCS proto/third_party_perception_component.proto
)

# ── apollo_third_party_perception library ──
apollo_cc_library(
    NAME apollo_third_party_perception
    SRCS
        common/third_party_perception_gflags.cc
        common/third_party_perception_util.cc
        third_party_perception_base.cc
        third_party_perception_mobileye.cc
        third_party_perception_smartereye.cc
        tools/conversion_mobileye.cc
        tools/conversion_radar.cc
        tools/conversion_smartereye.cc
        tools/filter.cc
        tools/fusion.cc
    HDRS
        common/third_party_perception_gflags.h
        common/third_party_perception_util.h
        third_party_perception_base.h
        third_party_perception_mobileye.h
        third_party_perception_smartereye.h
        tools/conversion_mobileye.h
        tools/conversion_radar.h
        tools/conversion_smartereye.h
        tools/filter.h
        tools/fusion.h
    DEPS
        cyber
        adapter_gflags
        common_math
        util_tool
        drive_state_cc_proto
        vehicle_signal_cc_proto
        chassis_cc_proto
        vehicle_config_cc_proto
        perception_obstacle_cc_proto
        conti_radar_cc_proto
        delphi_esr_cc_proto
        mobileye_cc_proto
        sensor_image_cc_proto
        smartereye_cc_proto
        apollo_map
        radar_obstacle_cc_proto
        third_party_perception_component_cc_proto
        gflags
        gtest_headers
    COPTS -DMODULE_NAME="third_party_perception"
)

# ── third_party_perception_component ──
apollo_component(
    NAME libthird_party_perception_component.so
    SRCS third_party_perception_component.cc
    HDRS third_party_perception_component.h
    DEPS
        apollo_third_party_perception
    COPTS -DMODULE_NAME="third_party_perception"
)
