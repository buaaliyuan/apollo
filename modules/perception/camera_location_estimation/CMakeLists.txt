# ============================================================================
# modules/perception/camera_location_estimation/CMakeLists.txt
# Component: libcamera_location_estimation_component_camera.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _cle_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_cle_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_camera_location_estimation_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_cle_proto_deps)
foreach(_proto ${_cle_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _cle_proto_deps "perception_camera_location_estimation_${_rs}_cc_proto")
endforeach()

# ── Main library ──
apollo_cc_library(
    NAME apollo_perception_camera_location_estimation
    SRCS
        transformer/multicue/multicue_transformer.cc
        transformer/multicue/obj_mapper.cc
        transformer/singlestage/singlestage_transformer.cc
    HDRS
        interface/base_transformer.h
        transformer/multicue/multicue_transformer.h
        transformer/multicue/obj_mapper.h
        transformer/singlestage/singlestage_transformer.h
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_camera
        apollo_perception_common_lib
        apollo_perception_common_onboard
        ${_cle_proto_deps}
        eigen
    COPTS -DMODULE_NAME="perception"
)

# ── Component .so ──
apollo_component(
    NAME libcamera_location_estimation_component_camera.so
    SRCS camera_location_estimation_component.cc
    HDRS camera_location_estimation_component.h
    DEPS
        apollo_perception_camera_location_estimation
        cyber
        apollo_perception_common_camera
        apollo_perception_common_onboard
    COPTS -DMODULE_NAME="perception"
)
