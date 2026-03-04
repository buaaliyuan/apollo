add_library(lattice_planner SHARED
    behavior/feasible_region.cc
    behavior/path_time_graph.cc
    behavior/prediction_querier.cc
    behavior/collision_checker.cc
    trajectory_generation/backup_trajectory_generator.cc
    trajectory_generation/end_condition_sampler.cc
    trajectory_generation/lateral_osqp_optimizer.cc
    trajectory_generation/lateral_qp_optimizer.cc
    trajectory_generation/lattice_trajectory1d.cc
    trajectory_generation/piecewise_braking_trajectory_generator.cc
    trajectory_generation/trajectory1d_generator.cc
    trajectory_generation/trajectory_combiner.cc
    trajectory_generation/trajectory_evaluator.cc

    lattice_planner.cc

)

target_link_libraries(lattice_planner PUBLIC
    cyber
    planning_base
)