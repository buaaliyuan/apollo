# ============================================================================
# modules/perception/camera_detection_single_stage/CMakeLists.txt
# Component: libcamera_detection_single_stage_component_camera.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _cdss_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_cdss_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_camera_detection_single_stage_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_cdss_proto_deps)
foreach(_proto ${_cdss_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _cdss_proto_deps "perception_camera_detection_single_stage_${_rs}_cc_proto")
endforeach()

# ── Detector libraries ──
file(GLOB_RECURSE _cdss_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER _cdss_srcs EXCLUDE REGEX ".*_test\\.cc$")
list(FILTER _cdss_srcs EXCLUDE REGEX ".*_component\\.cc$")

if(NOT APOLLO_USE_GPU)
    list(FILTER _cdss_srcs EXCLUDE REGEX ".*/detector/smoke/.*\\.cc$")
    list(FILTER _cdss_srcs EXCLUDE REGEX ".*/detector/caddn/.*\\.cc$")
endif()

if(_cdss_srcs)
    apollo_cc_library(
        NAME apollo_perception_camera_detection_single_stage
        SRCS ${_cdss_srcs}
        DEPS
            cyber
            apollo_perception_common_base
            apollo_perception_common_algorithm
            apollo_perception_common_camera
            apollo_perception_common_inference
            apollo_perception_common_lib
            apollo_perception_common_onboard
            perception_gflags
            perception_common_util
            sensor_image_cc_proto
            ${_cdss_proto_deps}
            eigen
        COPTS -DMODULE_NAME="perception"
    )
endif()

# ── Component .so ──
set(_cdss_comp_deps
    cyber
    apollo_perception_common_base
    apollo_perception_common_algorithm
    apollo_perception_common_camera
    apollo_perception_common_onboard
    perception_common_util
    sensor_image_cc_proto
    ${_cdss_proto_deps}
)
if(TARGET apollo_perception_camera_detection_single_stage)
    list(PREPEND _cdss_comp_deps apollo_perception_camera_detection_single_stage)
endif()

apollo_component(
    NAME libcamera_detection_single_stage_component_camera.so
    SRCS camera_detection_single_stage_component.cc
    HDRS camera_detection_single_stage_component.h
    DEPS ${_cdss_comp_deps}
    COPTS -DMODULE_NAME="perception"
)
