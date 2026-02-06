# ============================================================================
# modules/prediction/CMakeLists.txt
# ============================================================================

# ── Proto ──
apollo_proto_library(
    NAME fnn_model_base_cc_proto
    SRCS proto/fnn_model_base.proto
)

apollo_proto_library(
    NAME network_layers_cc_proto
    SRCS proto/network_layers.proto
)

apollo_proto_library(
    NAME fnn_vehicle_model_cc_proto
    SRCS proto/fnn_vehicle_model.proto
    DEPS fnn_model_base_cc_proto
)

apollo_proto_library(
    NAME network_model_cc_proto
    SRCS proto/network_model.proto
    DEPS network_layers_cc_proto
)

apollo_proto_library(
    NAME vector_net_cc_proto
    SRCS proto/vector_net.proto
)

apollo_proto_library(
    NAME prediction_conf_cc_proto
    SRCS proto/prediction_conf.proto
    DEPS prediction_obstacle_cc_proto
)

apollo_proto_library(
    NAME offline_features_cc_proto
    SRCS proto/offline_features.proto
    DEPS prediction_obstacle_cc_proto
)

# ── apollo_prediction_network library ──
apollo_cc_library(
    NAME apollo_prediction_network
    SRCS
        network/net_layer.cc
        network/net_model.cc
        network/net_util.cc
        network/rnn_model/rnn_model.cc
    HDRS
        network/net_layer.h
        network/net_model.h
        network/net_util.h
        network/rnn_model/rnn_model.h
    DEPS
        cyber
        network_model_cc_proto
        network_layers_cc_proto
        eigen
    COPTS -DMODULE_NAME="prediction"
)

# ── apollo_prediction main library ──
# Collect all source files
file(GLOB _pred_common_srcs common/*.cc)
list(FILTER _pred_common_srcs EXCLUDE REGEX ".*_test\\.cc$")
# Remove affine_transform on x86_64 (aarch64 only)
if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64")
    list(FILTER _pred_common_srcs EXCLUDE REGEX ".*affine_transform\\.cc$")
endif()

file(GLOB_RECURSE _pred_container_srcs container/*.cc)
list(FILTER _pred_container_srcs EXCLUDE REGEX ".*_test\\.cc$")

file(GLOB_RECURSE _pred_evaluator_srcs evaluator/*.cc)
list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*_test\\.cc$")
# Exclude libtorch-dependent evaluator files when torch not available
find_library(_torch_lib torch PATHS /opt/apollo/sysroot/lib ${CMAKE_SOURCE_DIR}/thirdparty/libtorch/lib NO_DEFAULT_PATH)
if(NOT _torch_lib)
    list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*torch.*\\.cc$")
    list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*warm_up\\.cc$")
    list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*pedestrian_interaction_evaluator\\.cc$")
    list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*semantic_lstm_evaluator\\.cc$")
    list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*multi_agent_evaluator\\.cc$")
    list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*jointly_prediction_planning_evaluator\\.cc$")
    list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*vectornet_evaluator\\.cc$")
    list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*junction_map_evaluator\\.cc$")
    list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*cruise_mlp_evaluator\\.cc$")
    list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*lane_scanning_evaluator\\.cc$")
    list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*lane_aggregating_evaluator\\.cc$")
    list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*junction_mlp_evaluator\\.cc$")
    list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*evaluator_manager\\.cc$")
    list(FILTER _pred_evaluator_srcs EXCLUDE REGEX ".*model_manager\\.cc$")
    # Add stub implementations for non-torch builds
    list(APPEND _pred_evaluator_srcs
        ${CMAKE_CURRENT_SOURCE_DIR}/evaluator/evaluator_manager_stub.cc)
endif()

file(GLOB _pred_pipeline_srcs pipeline/vector_net.cc)

file(GLOB_RECURSE _pred_predictor_srcs predictor/*.cc)
list(FILTER _pred_predictor_srcs EXCLUDE REGEX ".*_test\\.cc$")

file(GLOB_RECURSE _pred_scenario_srcs scenario/*.cc)
list(FILTER _pred_scenario_srcs EXCLUDE REGEX ".*_test\\.cc$")

file(GLOB _pred_submodule_srcs submodules/*.cc)

set(_pred_all_srcs
    ${_pred_common_srcs}
    ${_pred_container_srcs}
    ${_pred_evaluator_srcs}
    ${_pred_pipeline_srcs}
    ${_pred_predictor_srcs}
    ${_pred_scenario_srcs}
    ${_pred_submodule_srcs}
)

apollo_cc_library(
    NAME apollo_prediction
    SRCS ${_pred_all_srcs}
    DEPS
        cyber
        apollo_prediction_network
        adapter_gflags
        config_gflags
        vehicle_config_helper
        common_math
        monitor_log
        status
        common_util
        util_tool
        vehicle_state_provider
        apollo_map
        # Proto deps
        prediction_obstacle_cc_proto
        prediction_conf_cc_proto
        offline_features_cc_proto
        fnn_vehicle_model_cc_proto
        vector_net_cc_proto
        perception_obstacle_cc_proto
        localization_cc_proto
        planning_cc_proto
        story_cc_proto
        pnc_point_cc_proto
        geometry_cc_proto
        map_lane_cc_proto
        map_id_cc_proto
        routing_cc_proto
        # Third party
        gflags
        eigen
        absl
        ${OpenCV_LIBS}
    COPTS -DMODULE_NAME="prediction"
)

# ── prediction_component ──
apollo_component(
    NAME libprediction_component.so
    SRCS prediction_component.cc
    HDRS prediction_component.h
    DEPS
        apollo_prediction
        cyber
        adapter_gflags
        util_tool
    COPTS -DMODULE_NAME="prediction"
)

# ── Pipeline binaries ──
foreach(_bin vector_net_feature vector_net_offline_data records_to_offline_data)
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/pipeline/${_bin}.cc")
        apollo_cc_binary(
            NAME ${_bin}
            SRCS pipeline/${_bin}.cc
            DEPS apollo_prediction cyber gflags adapter_config_cc_proto
        )
    endif()
endforeach()
