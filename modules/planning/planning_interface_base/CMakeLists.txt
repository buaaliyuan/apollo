add_library(apollo_planning_planning_interface_base SHARED
    scenario_base/base_stage_creep.cc
    scenario_base/base_stage_cruise.cc
    scenario_base/process_result.cc
    scenario_base/scenario.cc
    scenario_base/stage.cc
    scenario_base/traffic_light_base/base_stage_traffic_light_creep.cc
    scenario_base/traffic_light_base/base_stage_traffic_light_cruise.cc
    task_base/common/decider.cc
    task_base/common/lane_change_util/lane_change_util.cc
    task_base/common/path_generation.cc
    task_base/common/path_util/path_assessment_decider_util.cc
    task_base/common/path_util/path_bounds_decider_util.cc
    task_base/common/path_util/path_optimizer_util.cc
    task_base/common/speed_optimizer.cc
    task_base/common/trajectory_optimizer.cc
    task_base/task.cc
    task_base/trajectory_fallback_task.cc
    task_base/utils/st_gap_estimator.cc
    traffic_rules_base/traffic_decider.cc
    traffic_rules_base/traffic_rule.cc
)

target_link_libraries(apollo_planning_planning_interface_base PUBLIC
    cyber
    Boost::thread
    gtest_headers
    Eigen3::Eigen
)