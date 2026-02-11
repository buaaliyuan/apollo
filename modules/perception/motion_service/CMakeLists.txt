# ============================================================================
# modules/perception/motion_service/CMakeLists.txt
# Component: libmotion_service_component.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _ms_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_ms_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_motion_service_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_ms_proto_deps)
foreach(_proto ${_ms_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _ms_proto_deps "perception_motion_service_${_rs}_cc_proto")
endforeach()

# ── Main library ──
apollo_cc_library(
    NAME apollo_perception_motion_service
    SRCS motion/plane_motion.cc
    HDRS motion/plane_motion.h
    DEPS
        apollo_perception_common_base
    COPTS -Wno-deprecated
)

# ── Component .so ──
apollo_component(
    NAME libmotion_service_component.so
    SRCS motion_service_component.cc
    HDRS motion_service_component.h
    DEPS
        apollo_perception_motion_service
        cyber
        apollo_perception_common_camera
        apollo_perception_common_lib
        perception_motion_service_cc_proto
        localization_cc_proto
        localization_status_cc_proto
        pose_cc_proto
        sensor_image_cc_proto
        ${_ms_proto_deps}
    COPTS -DMODULE_NAME="perception"
)
