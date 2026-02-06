# ============================================================================
# modules/map/CMakeLists.txt
# ============================================================================

# ── Proto ──
apollo_proto_library(
    NAME navigator_config_cc_proto
    SRCS relative_map/proto/navigator_config.proto
)

apollo_proto_library(
    NAME relative_map_config_cc_proto
    SRCS relative_map/proto/relative_map_config.proto
)

# ── Map datachecker protos ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/tools/map_datachecker/proto")
    file(GLOB _datachecker_protos tools/map_datachecker/proto/*.proto)
    if(_datachecker_protos)
        apollo_proto_library(
            NAME map_datachecker_cc_proto
            SRCS ${_datachecker_protos}
        )
    endif()
endif()

# ── apollo_map monolithic library ──
# Collect all source files from hdmap/, pnc_map/, relative_map/
file(GLOB_RECURSE _map_hdmap_srcs
    hdmap/*.cc
)
# Filter out test files
list(FILTER _map_hdmap_srcs EXCLUDE REGEX ".*_test\\.cc$")
list(FILTER _map_hdmap_srcs EXCLUDE REGEX ".*/test/.*")

file(GLOB _map_pnc_srcs pnc_map/*.cc)
list(FILTER _map_pnc_srcs EXCLUDE REGEX ".*_test\\.cc$")

file(GLOB _map_relative_srcs
    relative_map/*.cc
    relative_map/common/*.cc
    relative_map/tools/*.cc
)
list(FILTER _map_relative_srcs EXCLUDE REGEX ".*_test\\.cc$")

set(_map_all_srcs ${_map_hdmap_srcs} ${_map_pnc_srcs} ${_map_relative_srcs})

apollo_cc_library(
    NAME apollo_map
    SRCS ${_map_all_srcs}
    DEPS
        cyber
        adapter_gflags
        vehicle_config_helper
        common_math
        monitor_log
        status
        common_util
        util_tool
        vehicle_state_provider
        # Proto dependencies
        geometry_cc_proto
        header_cc_proto
        map_clear_area_cc_proto
        map_crosswalk_cc_proto
        map_geometry_cc_proto
        map_id_cc_proto
        map_junction_cc_proto
        map_lane_cc_proto
        map_overlap_cc_proto
        map_parking_space_cc_proto
        map_pnc_junction_cc_proto
        map_road_cc_proto
        map_rsu_cc_proto
        map_signal_cc_proto
        map_speed_bump_cc_proto
        map_speed_control_cc_proto
        map_stop_sign_cc_proto
        map_yield_sign_cc_proto
        map_cc_proto
        navigation_cc_proto
        routing_cc_proto
        localization_cc_proto
        pnc_point_cc_proto
        relative_map_config_cc_proto
        navigator_config_cc_proto
        # Third party
        Boost::filesystem
        Boost::program_options
        gflags
        glog::glog
        yaml-cpp
        absl
        eigen
        proj_lib
        tinyxml2
    COPTS -DMODULE_NAME="map"
)

# ── relative_map_component ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/relative_map/relative_map_component.cc")
    apollo_component(
        NAME librelative_map_component.so
        SRCS relative_map/relative_map_component.cc
        HDRS relative_map/relative_map_component.h
        DEPS
            apollo_map
            cyber
        COPTS -DMODULE_NAME="map"
    )
endif()

# ── Map tools ──
set(_map_tools
    map_tool
    map_xysl
    sim_map_generator
    proto_map_generator
    bin_map_generator
    quaternion_euler
    refresh_default_end
)
foreach(_tool ${_map_tools})
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/tools/${_tool}.cc")
        apollo_cc_binary(
            NAME ${_tool}
            SRCS tools/${_tool}.cc
            DEPS apollo_map cyber gflags
        )
    endif()
endforeach()
