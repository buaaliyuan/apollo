# ============================================================================
# modules/perception/traffic_light_detection/CMakeLists.txt
# Component: libcomponent_traffic_light_detect.so
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _tld_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_tld_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_traffic_light_detection_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_tld_proto_deps)
foreach(_proto ${_tld_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _tld_proto_deps "perception_traffic_light_detection_${_rs}_cc_proto")
endforeach()

# ── Main library ──
set(_tld_srcs
    algorithm/cropbox.cc
    algorithm/select.cc
)

# GPU-dependent detectors
if(APOLLO_USE_GPU)
    list(APPEND _tld_srcs
        detector/caffe_detection/detection.cc
        detector/yolox_detection/traffic_light_detection_yolox.cc
    )
endif()

apollo_cc_library(
    NAME apollo_perception_traffic_light_detection
    SRCS ${_tld_srcs}
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_algorithm
        apollo_perception_common_camera
        apollo_perception_common_inference
        apollo_perception_common_lib
        apollo_perception_common_onboard
        perception_common_util
        ${_tld_proto_deps}
        ${OpenCV_LIBS}
    COPTS -DMODULE_NAME="trafficlight"
)

# ── Component .so ──
apollo_component(
    NAME libcomponent_traffic_light_detect.so
    SRCS traffic_light_detection_component.cc
    HDRS traffic_light_detection_component.h
    DEPS
        apollo_perception_traffic_light_detection
        cyber
        apollo_perception_common_camera
        apollo_perception_common_onboard
        ${_tld_proto_deps}
    COPTS -DMODULE_NAME="trafficlight"
)
