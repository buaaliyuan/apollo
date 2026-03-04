add_library(control_task_extend SHARED 
    common/control_checker.cc
    common/exponential_smoothing.cc
    common/interpolation_plus_1d.cc
    common/leadlag_plus_controller.cc
    common/math_utils.cc
    common/pid_plus_controller.cc
    common/trajectory_analyzer_extend.cc
    control_task_extend.cc
    proto/params_pipeline.pb.cc
    proto/pid_plus_conf.pb.cc
    proto/safety_check_conf.pb.cc
)


target_link_libraries(control_task_extend PUBLIC
    cyber
    Eigen3::Eigen
)