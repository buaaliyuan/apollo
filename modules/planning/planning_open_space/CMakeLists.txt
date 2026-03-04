add_library(apollo_planning_open_space SHARED
    coarse_trajectory_generator/grid_search.cc
    coarse_trajectory_generator/hybrid_a_star.cc
    coarse_trajectory_generator/node3d.cc
    coarse_trajectory_generator/reeds_shepp_path.cc
    trajectory_smoother/distance_approach_ipopt_cuda_interface.cc
    trajectory_smoother/distance_approach_ipopt_fixed_dual_interface.cc
    trajectory_smoother/distance_approach_ipopt_fixed_ts_interface.cc
    trajectory_smoother/distance_approach_ipopt_interface.cc
    trajectory_smoother/distance_approach_ipopt_relax_end_interface.cc
    trajectory_smoother/distance_approach_ipopt_relax_end_slack_interface.cc
    trajectory_smoother/distance_approach_problem.cc
    trajectory_smoother/dual_variable_warm_start_ipopt_interface.cc
    trajectory_smoother/dual_variable_warm_start_ipopt_qp_interface.cc
    trajectory_smoother/dual_variable_warm_start_osqp_interface.cc
    trajectory_smoother/dual_variable_warm_start_problem.cc
    trajectory_smoother/dual_variable_warm_start_slack_osqp_interface.cc
    trajectory_smoother/iterative_anchoring_smoother.cc
    utils/open_space_fallback_util.cc
    utils/open_space_roi_util.cc
    utils/open_space_trajectory_optimizer_util.cc
)

target_link_libraries(apollo_planning_open_space PUBLIC
    cyber
    planning_base
)

target_compile_options(apollo_planning_open_space PRIVATE
    -fopenmp
)