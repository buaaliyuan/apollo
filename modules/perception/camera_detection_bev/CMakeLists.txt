# ============================================================================
# modules/perception/camera_detection_bev/CMakeLists.txt
# Component: libcamera_detection_bev_component.so
# Note: BUILD uses apollo_cc_library for component (not apollo_component)
# ============================================================================

# ── Protos ──
file(GLOB_RECURSE _cdb_protos "${CMAKE_CURRENT_SOURCE_DIR}/*.proto")
foreach(_proto ${_cdb_protos})
    file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
    string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
    apollo_proto_library(
        NAME perception_camera_detection_bev_${_rel_safe}_cc_proto
        SRCS ${_proto}
    )
endforeach()

set(_cdb_proto_deps)
foreach(_proto ${_cdb_protos})
    file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
    string(REPLACE "/" "_" _rs "${_rel}")
    string(REPLACE ".proto" "" _rs "${_rs}")
    list(APPEND _cdb_proto_deps "perception_camera_detection_bev_${_rs}_cc_proto")
endforeach()

# ── Main library ──
apollo_cc_library(
    NAME apollo_perception_camera_detection_bev
    SRCS
        detector/petr/bev_obstacle_detector.cc
        detector/petr/postprocess.cc
        detector/petr/preprocess.cc
        interface/base_obstacle_detector.cc
    HDRS
        camera_frame.h
        detector/petr/bev_obstacle_detector.h
        detector/petr/postprocess.h
        detector/petr/preprocess.h
        interface/base_obstacle_detector.h
    DEPS
        cyber
        apollo_perception_common_base
        apollo_perception_common_camera
        apollo_perception_common_inference
        apollo_perception_common_lib
        apollo_perception_common_onboard
        perception_common_util
        perception_model_info_cc_proto
        perception_model_process_cc_proto
        sensor_image_cc_proto
        ${_cdb_proto_deps}
        protobuf::libprotobuf
        eigen
        ${OpenCV_LIBS}
    COPTS -DMODULE_NAME="perception"
)

# ── Component .so ──
apollo_component(
    NAME libcamera_detection_bev_component.so
    SRCS camera_detection_bev_component.cc
    HDRS camera_detection_bev_component.h
    DEPS
        apollo_perception_camera_detection_bev
        cyber
        apollo_perception_common_base
        apollo_perception_common_camera
        apollo_perception_common_onboard
        perception_common_util
        sensor_image_cc_proto
        ${_cdb_proto_deps}
        perception_plugin_param_cc_proto
    COPTS -DMODULE_NAME="perception"
)
