# ============================================================================
# modules/perception/barrier_recognition/CMakeLists.txt
# Component: libbarrier_recognition_component.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _br_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_br_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_barrier_recognition_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_br_proto_deps)
foreach(_proto ${_br_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _br_proto_deps "perception_barrier_recognition_${_rs}_cc_proto")
endforeach()

# ── Main library ──
apollo_cc_library(
    NAME apollo_perception_barrier_recognition
    SRCS
        detector/barrier_recognition_bank.cc
        tracker/barrier_status_tracker.cc
    HDRS
        interface/base_barrier_recognizer.h
        detector/barrier_recognition_bank.h
        tracker/barrier_status_tracker.h
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_lib
        apollo_perception_common_lidar
        apollo_perception_common_onboard
        apollo_perception_common_hdmap
        pointcloud_cc_proto
        perception_obstacle_cc_proto
        perception_barrier_gate_cc_proto
        ${_br_proto_deps}
    COPTS -DMODULE_NAME="perception"
)

# ── Component .so ──
apollo_component(
    NAME libbarrier_recognition_component.so
    SRCS barrier_recognition_component.cc
    HDRS barrier_recognition_component.h
    DEPS
        apollo_perception_barrier_recognition
        cyber
        apollo_perception_common_onboard
        perception_barrier_gate_cc_proto
        ${_br_proto_deps}
    COPTS -DMODULE_NAME="perception"
    LINKOPTS -lleveldb
)
