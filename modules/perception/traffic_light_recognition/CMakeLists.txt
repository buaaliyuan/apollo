# ============================================================================
# modules/perception/traffic_light_recognition/CMakeLists.txt
# Component: libcomponent_traffic_light_recognition.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _tlr_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_tlr_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_traffic_light_recognition_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_tlr_proto_deps)
foreach(_proto ${_tlr_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _tlr_proto_deps "perception_traffic_light_recognition_${_rs}_cc_proto")
endforeach()

# ── Main library ──
set(_tlr_srcs)

if(APOLLO_USE_GPU)
    set(_tlr_srcs
        recognition/caffe_recognizer/classify.cc
        recognition/caffe_recognizer/recognition.cc
        recognition/efficient_net/efficient_net.cc
    )
else()
    # Exclude GPU-dependent recognizers
    file(GLOB_RECURSE _tlr_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
    list(FILTER _tlr_srcs EXCLUDE REGEX ".*_test\\.cc$")
    list(FILTER _tlr_srcs EXCLUDE REGEX ".*_component\\.cc$")
    list(FILTER _tlr_srcs EXCLUDE REGEX ".*/caffe_recognizer/.*\\.cc$")
    list(FILTER _tlr_srcs EXCLUDE REGEX ".*/efficient_net/.*\\.cc$")
endif()

if(_tlr_srcs)
    apollo_cc_library(
        NAME apollo_perception_traffic_light_recognition
        SRCS ${_tlr_srcs}
        DEPS
            cyber
            apollo_perception_common_base
            apollo_perception_common_camera
            apollo_perception_common_inference
            apollo_perception_common_lib
            apollo_perception_common_onboard
            perception_common_util
            ${_tlr_proto_deps}
        COPTS -DMODULE_NAME="trafficlight"
    )
else()
    apollo_cc_library(
        NAME apollo_perception_traffic_light_recognition
        INTERFACE
        DEPS cyber apollo_perception_common_onboard
    )
endif()

# ── Component .so ──
apollo_component(
    NAME libcomponent_traffic_light_recognition.so
    SRCS traffic_light_recognition_component.cc
    HDRS traffic_light_recognition_component.h
    DEPS
        apollo_perception_traffic_light_recognition
        cyber
        apollo_perception_common_camera
        apollo_perception_common_onboard
        ${_tlr_proto_deps}
    COPTS -DMODULE_NAME="trafficlight"
)
