# ============================================================================
# modules/perception/perception_plugin/CMakeLists.txt
# Plugins: dynamically loaded algorithm plugins
# ============================================================================

# ── lidar_detection/gpu_down_sample plugin (GPU only) ──
if(APOLLO_USE_GPU AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection/gpu_down_sample")
    file(GLOB_RECURSE _gds_protos
        "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection/gpu_down_sample/*.proto")
    foreach(_proto ${_gds_protos})
        file(RELATIVE_PATH _rel_proto "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
        string(REPLACE "/" "_" _rel_safe "${_rel_proto}")
        string(REPLACE ".proto" "" _rel_safe "${_rel_safe}")
        apollo_proto_library(
            NAME perception_plugin_${_rel_safe}_cc_proto
            SRCS ${_proto}
        )
    endforeach()

    set(_gds_proto_deps)
    foreach(_proto ${_gds_protos})
        file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
        string(REPLACE "/" "_" _rs "${_rel}")
        string(REPLACE ".proto" "" _rs "${_rs}")
        list(APPEND _gds_proto_deps "perception_plugin_${_rs}_cc_proto")
    endforeach()

    apollo_plugin(
        NAME libgpu_down_sample.so
        SRCS lidar_detection/gpu_down_sample/gpu_down_sample.cc
        HDRS lidar_detection/gpu_down_sample/gpu_down_sample.h
        DESCRIPTION lidar_detection/gpu_down_sample/plugins.xml
        DEPS
            cyber
            apollo_perception_common_lidar
            apollo_perception_common_interface
            perception_common_util
            ${_gds_proto_deps}
            ${CUDA_LIBRARIES}
        COPTS -DMODULE_NAME="perception"
    )
endif()

# ── inference/onnx_multi_batch plugin (GPU only) ──
if(APOLLO_USE_GPU AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/inference/onnx_multi_batch")
    apollo_plugin(
        NAME libonnx_multi_batch.so
        SRCS inference/onnx_multi_batch/onnx_multi_batch_infer.cc
        HDRS inference/onnx_multi_batch/onnx_multi_batch_infer.h
        DESCRIPTION inference/onnx_multi_batch/plugins.xml
        DEPS
            cyber
            apollo_perception_common_inference
            perception_gflags
            perception_common_util
            ${CUDA_LIBRARIES} ${CUDA_CUBLAS_LIBRARIES}
        COPTS -DMODULE_NAME="perception"
    )
    if(TARGET onnx_multi_batch AND APOLLO_USE_GPU)
        target_include_directories(onnx_multi_batch PUBLIC ${CUDA_INCLUDE_DIRS})
        if(TARGET tensorrt)
            target_link_libraries(onnx_multi_batch PRIVATE tensorrt)
        endif()
        if(TARGET cudnn)
            target_link_libraries(onnx_multi_batch PRIVATE cudnn)
        endif()
    endif()
endif()

# ── lidar_detection_filter plugins ──
# bigmot_refine_filter
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection_filter/bigmot_refine_filter")
    file(GLOB_RECURSE _bmf_protos
        "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection_filter/bigmot_refine_filter/*.proto")
    set(_bmf_proto_deps)
    foreach(_proto ${_bmf_protos})
        file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
        string(REPLACE "/" "_" _rs "${_rel}")
        string(REPLACE ".proto" "" _rs "${_rs}")
        apollo_proto_library(
            NAME perception_plugin_${_rs}_cc_proto
            SRCS ${_proto}
        )
        list(APPEND _bmf_proto_deps "perception_plugin_${_rs}_cc_proto")
    endforeach()

    apollo_plugin(
        NAME libbigmot_refine_filter.so
        SRCS lidar_detection_filter/bigmot_refine_filter/bigmot_refine_filter.cc
        HDRS lidar_detection_filter/bigmot_refine_filter/bigmot_refine_filter.h
        DESCRIPTION lidar_detection_filter/bigmot_refine_filter/plugins.xml
        DEPS
            cyber
            apollo_perception_common_lib
            apollo_perception_lidar_detection_filter
            perception_common_util
            ${_bmf_proto_deps}
        COPTS -DMODULE_NAME="perception"
    )
endif()

# mark_area_filter
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection_filter/mark_area_filter")
    file(GLOB_RECURSE _maf_protos
        "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection_filter/mark_area_filter/*.proto")
    set(_maf_proto_deps)
    foreach(_proto ${_maf_protos})
        file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
        string(REPLACE "/" "_" _rs "${_rel}")
        string(REPLACE ".proto" "" _rs "${_rs}")
        apollo_proto_library(
            NAME perception_plugin_${_rs}_cc_proto
            SRCS ${_proto}
        )
        list(APPEND _maf_proto_deps "perception_plugin_${_rs}_cc_proto")
    endforeach()

    apollo_plugin(
        NAME libmark_area_filter.so
        SRCS lidar_detection_filter/mark_area_filter/mark_area_filter.cc
        HDRS lidar_detection_filter/mark_area_filter/mark_area_filter.h
        DESCRIPTION lidar_detection_filter/mark_area_filter/plugins.xml
        DEPS
            cyber
            apollo_perception_common_lib
            apollo_perception_lidar_detection_filter
            perception_common_util
            ${_maf_proto_deps}
        COPTS -DMODULE_NAME="perception"
    )
endif()

# object_split_filter
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection_filter/object_split_filter")
    file(GLOB_RECURSE _osf_protos
        "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection_filter/object_split_filter/*.proto")
    set(_osf_proto_deps)
    foreach(_proto ${_osf_protos})
        file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
        string(REPLACE "/" "_" _rs "${_rel}")
        string(REPLACE ".proto" "" _rs "${_rs}")
        apollo_proto_library(
            NAME perception_plugin_${_rs}_cc_proto
            SRCS ${_proto}
        )
        list(APPEND _osf_proto_deps "perception_plugin_${_rs}_cc_proto")
    endforeach()

    set(_osf_extra_deps)
    if(TARGET lidar_segmentation_common)
        list(APPEND _osf_extra_deps lidar_segmentation_common)
    endif()

    apollo_plugin(
        NAME libobject_split_filter.so
        SRCS lidar_detection_filter/object_split_filter/object_split_filter.cc
        HDRS lidar_detection_filter/object_split_filter/object_split_filter.h
        DESCRIPTION lidar_detection_filter/object_split_filter/plugins.xml
        DEPS
            cyber
            apollo_perception_common_lib
            apollo_perception_lidar_detection_filter
            perception_common_util
            ${_osf_proto_deps}
            ${_osf_extra_deps}
            eigen
        COPTS -DMODULE_NAME="perception"
    )
endif()

# semantic_filter
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection_filter/semantic_filter")
    file(GLOB_RECURSE _sf_protos
        "${CMAKE_CURRENT_SOURCE_DIR}/lidar_detection_filter/semantic_filter/*.proto")
    set(_sf_proto_deps)
    foreach(_proto ${_sf_protos})
        file(RELATIVE_PATH _rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_proto}")
        string(REPLACE "/" "_" _rs "${_rel}")
        string(REPLACE ".proto" "" _rs "${_rs}")
        apollo_proto_library(
            NAME perception_plugin_${_rs}_cc_proto
            SRCS ${_proto}
        )
        list(APPEND _sf_proto_deps "perception_plugin_${_rs}_cc_proto")
    endforeach()

    apollo_plugin(
        NAME libsemantic_filter.so
        SRCS lidar_detection_filter/semantic_filter/semantic_filter.cc
        HDRS lidar_detection_filter/semantic_filter/semantic_filter.h
        DESCRIPTION lidar_detection_filter/semantic_filter/plugins.xml
        DEPS
            cyber
            apollo_perception_common_lib
            apollo_perception_lidar_detection_filter
            perception_common_util
            ${_sf_proto_deps}
        COPTS -DMODULE_NAME="perception"
    )
endif()
