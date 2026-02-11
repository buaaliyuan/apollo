# ============================================================================
# modules/perception/camera_location_refinement/CMakeLists.txt
# Component: libcamera_location_refinement_component_camera.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _clr_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_clr_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_camera_location_refinement_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_clr_proto_deps)
foreach(_proto ${_clr_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _clr_proto_deps "perception_camera_location_refinement_${_rs}_cc_proto")
endforeach()

# ── Main library ──
apollo_cc_library(
    NAME apollo_perception_camera_location_refinement
    SRCS
        location_refiner/location_refiner_postprocessor.cc
        location_refiner/obj_postprocessor.cc
    HDRS
        interface/base_postprocessor.h
        location_refiner/location_refiner_postprocessor.h
        location_refiner/obj_postprocessor.h
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        apollo_perception_common_camera
        apollo_perception_common_lib
        apollo_perception_common_onboard
        perception_common_util
        ${_clr_proto_deps}
    COPTS -DMODULE_NAME="perception"
)

# ── Component .so ──
apollo_component(
    NAME libcamera_location_refinement_component_camera.so
    SRCS camera_location_refinement_component.cc
    HDRS camera_location_refinement_component.h
    DEPS
        apollo_perception_camera_location_refinement
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        apollo_perception_common_camera
        apollo_perception_common_lib
        apollo_perception_common_onboard
        perception_common_util
    COPTS -DMODULE_NAME="perception"
)
