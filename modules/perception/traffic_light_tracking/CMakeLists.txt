# ============================================================================
# modules/perception/traffic_light_tracking/CMakeLists.txt
# Component: libcomponent_traffic_light_tracking.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _tlt_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_tlt_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_traffic_light_tracking_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_tlt_proto_deps)
foreach(_proto ${_tlt_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _tlt_proto_deps "perception_traffic_light_tracking_${_rs}_cc_proto")
endforeach()

# ── Main library ──
apollo_cc_library(
    NAME apollo_perception_traffic_light_tracking
    SRCS
        tracker/semantic_decision.cc
    HDRS
        interface/base_traffic_light_tracker.h
        tracker/semantic_decision.h
    DEPS
        cyber
        apollo_perception_common_camera
        apollo_perception_common_lib
        apollo_perception_common_onboard
        perception_common_util
        traffic_light_detection_cc_proto
        v2x_traffic_light_cc_proto
        ${_tlt_proto_deps}
        ${OpenCV_LIBS}
    COPTS -DMODULE_NAME="trafficlight"
)

# ── Component .so ──
apollo_component(
    NAME libcomponent_traffic_light_tracking.so
    SRCS traffic_light_tracking_component.cc
    HDRS traffic_light_tracking_component.h
    DEPS
        apollo_perception_traffic_light_tracking
        cyber
        apollo_perception_common_camera
        apollo_perception_common_onboard
        traffic_light_detection_cc_proto
        v2x_traffic_light_cc_proto
        ${_tlt_proto_deps}
        ${OpenCV_LIBS}
    COPTS -DMODULE_NAME="trafficlight"
)
