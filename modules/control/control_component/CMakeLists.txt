add_library(control_component SHARED
    common/control_gflags.cc
    control_component.cc
    controller_task_base/common/hysteresis_filter.cc
    controller_task_base/common/interpolation_1d.cc
    controller_task_base/common/interpolation_2d.cc
    controller_task_base/common/leadlag_controller.cc
    controller_task_base/common/mrac_controller.cc
    controller_task_base/common/pid_BC_controller.cc
    controller_task_base/common/pid_controller.cc
    controller_task_base/common/pid_IC_controller.cc
    controller_task_base/common/trajectory_analyzer.cc
    controller_task_base/control_task_agent.cc
    controller_task_base/integration_tests/control_test_base.cc
    proto/calibration_debug.pb.cc
    proto/calibration_table.pb.cc
    proto/check_status.pb.cc
    proto/control_debug.pb.cc
    proto/gain_scheduler_conf.pb.cc
    proto/leadlag_conf.pb.cc
    proto/local_view.pb.cc
    proto/mrac_conf.pb.cc
    proto/pid_conf.pb.cc
    proto/pipeline.pb.cc
    proto/plugin_declare_info.pb.cc
    proto/preprocessor.pb.cc
    submodules/lat_lon_controller_submodule.cc
    submodules/mpc_controller_submodule.cc
    submodules/postprocessor_submodule.cc
    submodules/preprocessor_submodule.cc
    # tools/calibration_table_debug.cc
    # tools/control_tester.cc
    # tools/pad_terminal.cc
)

target_link_libraries(control_component PUBLIC
    cyber
    gtest_headers
    Eigen3::Eigen
)
target_compile_definitions(control_component PUBLIC
    MODULE_NAME="control"
)
install(TARGETS control_component
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)