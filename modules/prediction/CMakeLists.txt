add_library(prediction_component SHARED
    prediction_component.cc

    network/net_layer.cc
    network/net_model.cc
    network/net_util.cc
    network/rnn_model/rnn_model.cc

    common/affine_transform.cc
    common/environment_features.cc
    common/feature_output.cc
    common/junction_analyzer.cc
    common/message_process.cc
    common/prediction_gflags.cc
    common/prediction_map.cc
    common/prediction_system_gflags.cc
    common/prediction_thread_pool.cc
    common/prediction_util.cc
    common/road_graph.cc
    common/semantic_map.cc
    common/validation_checker.cc
    container/adc_trajectory/adc_trajectory_container.cc
    container/container_manager.cc
    container/obstacles/obstacle.cc
    container/obstacles/obstacle_clusters.cc
    container/obstacles/obstacles_container.cc
    container/pose/pose_container.cc
    container/storytelling/storytelling_container.cc
    evaluator/cyclist/cyclist_keep_lane_evaluator.cc
    evaluator/evaluator_manager.cc
    evaluator/model_manager/model_manager.cc
    evaluator/pedestrian/pedestrian_interaction_evaluator.cc
    evaluator/vehicle/cost_evaluator.cc
    evaluator/vehicle/cruise_mlp_evaluator.cc
    evaluator/vehicle/jointly_prediction_planning_evaluator.cc
    evaluator/vehicle/junction_map_evaluator.cc
    evaluator/vehicle/junction_mlp_evaluator.cc
    evaluator/vehicle/lane_aggregating_evaluator.cc
    evaluator/vehicle/lane_scanning_evaluator.cc
    evaluator/vehicle/mlp_evaluator.cc
    evaluator/vehicle/semantic_lstm_evaluator.cc
    evaluator/vehicle/vectornet_evaluator.cc
    evaluator/vehicle/multi_agent_evaluator.cc
    evaluator/warm_up/warm_up.cc
    pipeline/vector_net.cc
    predictor/empty/empty_predictor.cc
    predictor/extrapolation/extrapolation_predictor.cc
    predictor/free_move/free_move_predictor.cc
    predictor/interaction/interaction_predictor.cc
    predictor/junction/junction_predictor.cc
    predictor/lane_sequence/lane_sequence_predictor.cc
    predictor/move_sequence/move_sequence_predictor.cc
    predictor/predictor.cc
    predictor/predictor_manager.cc
    predictor/sequence/sequence_predictor.cc
    predictor/single_lane/single_lane_predictor.cc
    scenario/analyzer/scenario_analyzer.cc
    scenario/feature_extractor/feature_extractor.cc
    scenario/interaction_filter/interaction_filter.cc
    scenario/prioritization/obstacles_prioritizer.cc
    scenario/right_of_way/right_of_way.cc
    scenario/scenario_features/cruise_scenario_features.cc
    scenario/scenario_features/junction_scenario_features.cc
    scenario/scenario_features/scenario_features.cc
    scenario/scenario_manager.cc
    submodules/evaluator_submodule.cc
    submodules/predictor_submodule.cc
    submodules/submodule_output.cc

    proto/vector_net.pb.cc
    proto/fnn_model_base.pb.cc
    proto/fnn_vehicle_model.pb.cc
    proto/network_layers.pb.cc
    proto/network_model.pb.cc
    proto/offline_features.pb.cc
    proto/prediction_conf.pb.cc
)


target_include_directories(prediction_component PUBLIC
    ${OpenCV_INCLUDE_DIRS}
    ${CUDA_INCLUDE_DIRS}
    ${TORCH_INCLUDE_DIRS}
    ${PYTHON_INCLUDE_DIRS}
)

target_link_libraries(prediction_component PUBLIC
    cyber
    gtest_headers
    ${OpenCV_LIBS}
    Eigen3::Eigen
    Boost::filesystem
    ${TORCH_LIBRARIES}
    ${PYTHON_LIBRARIES}
)

target_compile_definitions(prediction_component PUBLIC
    MODULE_NAME="prediction"
)

