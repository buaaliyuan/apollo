# ============================================================================
# modules/control/CMakeLists.txt
# ============================================================================

# ── Proto (control_component/proto/) ──
apollo_proto_library(
    NAME pid_conf_cc_proto
    SRCS control_component/proto/pid_conf.proto
)

apollo_proto_library(
    NAME leadlag_conf_cc_proto
    SRCS control_component/proto/leadlag_conf.proto
)

apollo_proto_library(
    NAME mrac_conf_cc_proto
    SRCS control_component/proto/mrac_conf.proto
)

apollo_proto_library(
    NAME gain_scheduler_conf_cc_proto
    SRCS control_component/proto/gain_scheduler_conf.proto
)

apollo_proto_library(
    NAME calibration_table_cc_proto
    SRCS control_component/proto/calibration_table.proto
)

apollo_proto_library(
    NAME check_status_cc_proto
    SRCS control_component/proto/check_status.proto
)

apollo_proto_library(
    NAME control_plugin_declare_info_cc_proto
    SRCS control_component/proto/plugin_declare_info.proto
)

apollo_proto_library(
    NAME control_debug_cc_proto
    SRCS control_component/proto/control_debug.proto
    DEPS header_cc_proto chassis_cc_proto
)

apollo_proto_library(
    NAME preprocessor_cc_proto
    SRCS control_component/proto/preprocessor.proto
    DEPS header_cc_proto local_view_cc_proto
)

apollo_proto_library(
    NAME local_view_cc_proto
    SRCS control_component/proto/local_view.proto
    DEPS chassis_cc_proto planning_cc_proto localization_cc_proto
         control_pad_msg_cc_proto control_cmd_cc_proto
)

apollo_proto_library(
    NAME pipeline_cc_proto
    SRCS control_component/proto/pipeline.proto
    DEPS control_plugin_declare_info_cc_proto
)

apollo_proto_library(
    NAME calibration_debug_cc_proto
    SRCS control_component/proto/calibration_debug.proto
    DEPS calibration_table_cc_proto
)

# ── Proto (control_task_base_extend/proto/) ──
apollo_proto_library(
    NAME pid_plus_conf_cc_proto
    SRCS control_task_base_extend/proto/pid_plus_conf.proto
    DEPS pid_conf_cc_proto
)

apollo_proto_library(
    NAME params_pipeline_cc_proto
    SRCS control_task_base_extend/proto/params_pipeline.proto
)

apollo_proto_library(
    NAME safety_check_conf_cc_proto
    SRCS control_task_base_extend/proto/safety_check_conf.proto
)

# ── control_gflags ──
apollo_cc_library(
    NAME control_gflags
    SRCS control_component/common/control_gflags.cc
    HDRS control_component/common/control_gflags.h
    DEPS gflags
)

# ── controller_task_base/common libraries ──
apollo_cc_library(
    NAME hysteresis_filter
    SRCS control_component/controller_task_base/common/hysteresis_filter.cc
    HDRS control_component/controller_task_base/common/hysteresis_filter.h
    COPTS -DMODULE_NAME="control"
)

apollo_cc_library(
    NAME interpolation_1d
    SRCS control_component/controller_task_base/common/interpolation_1d.cc
    HDRS control_component/controller_task_base/common/interpolation_1d.h
    DEPS cyber eigen
    COPTS -DMODULE_NAME="control"
)

apollo_cc_library(
    NAME interpolation_2d
    SRCS control_component/controller_task_base/common/interpolation_2d.cc
    HDRS control_component/controller_task_base/common/interpolation_2d.h
    DEPS cyber control_gflags
    COPTS -DMODULE_NAME="control"
)

apollo_cc_library(
    NAME leadlag_controller
    SRCS control_component/controller_task_base/common/leadlag_controller.cc
    HDRS control_component/controller_task_base/common/leadlag_controller.h
    DEPS cyber leadlag_conf_cc_proto
    COPTS -DMODULE_NAME="control"
)

apollo_cc_library(
    NAME pid_controller
    SRCS control_component/controller_task_base/common/pid_controller.cc
    HDRS control_component/controller_task_base/common/pid_controller.h
    DEPS cyber pid_conf_cc_proto
    COPTS -DMODULE_NAME="control"
)

apollo_cc_library(
    NAME pid_BC_controller
    SRCS control_component/controller_task_base/common/pid_BC_controller.cc
    HDRS control_component/controller_task_base/common/pid_BC_controller.h
    DEPS pid_controller cyber common_math pid_conf_cc_proto
    COPTS -DMODULE_NAME="control"
)

apollo_cc_library(
    NAME pid_IC_controller
    SRCS control_component/controller_task_base/common/pid_IC_controller.cc
    HDRS control_component/controller_task_base/common/pid_IC_controller.h
    DEPS pid_controller cyber common_math pid_conf_cc_proto
    COPTS -DMODULE_NAME="control"
)

apollo_cc_library(
    NAME mrac_controller
    SRCS control_component/controller_task_base/common/mrac_controller.cc
    HDRS control_component/controller_task_base/common/mrac_controller.h
    DEPS
        cyber common_math status
        vehicle_config_cc_proto mrac_conf_cc_proto
        absl eigen
    COPTS -DMODULE_NAME="control"
)

apollo_cc_library(
    NAME trajectory_analyzer
    SRCS control_component/controller_task_base/common/trajectory_analyzer.cc
    HDRS control_component/controller_task_base/common/trajectory_analyzer.h
    DEPS
        cyber common_math vehicle_state_provider
        pnc_point_cc_proto planning_cc_proto
        control_gflags eigen
    COPTS -DMODULE_NAME="control"
)

# ── Aggregate common library ──
apollo_cc_library(
    NAME controllers_control_task_base_common
    HDRS control_component/controller_task_base/common/dependency_injector.h
    DEPS
        hysteresis_filter interpolation_1d interpolation_2d
        leadlag_controller mrac_controller
        pid_BC_controller pid_IC_controller pid_controller
        trajectory_analyzer
        cyber common_math status
        vehicle_state_provider
        vehicle_config_cc_proto
        leadlag_conf_cc_proto mrac_conf_cc_proto pid_conf_cc_proto
        control_debug_cc_proto
        command_status_cc_proto
        control_interactive_msg_cc_proto
        absl eigen
)

# ── control_task ──
apollo_cc_library(
    NAME control_task
    HDRS control_component/controller_task_base/control_task.h
    DEPS
        cyber
        controllers_control_task_base_common
        calibration_table_cc_proto
    COPTS -DMODULE_NAME="control"
)

# ── control_task_agent ──
apollo_cc_library(
    NAME control_task_agent
    SRCS control_component/controller_task_base/control_task_agent.cc
    HDRS control_component/controller_task_base/control_task_agent.h
    DEPS
        control_task
        cyber
        util_tool
        control_cmd_cc_proto
        planning_cc_proto
        control_gflags
        pipeline_cc_proto
        controllers_control_task_base_common
        osqp
    COPTS -DMODULE_NAME="control"
)

# ── Submodules ──
apollo_cc_library(
    NAME preprocessor_submodule_lib
    SRCS control_component/submodules/preprocessor_submodule.cc
    HDRS control_component/submodules/preprocessor_submodule.h
    DEPS
        cyber control_task_agent controllers_control_task_base_common
        control_gflags adapter_gflags monitor_log
        chassis_cc_proto control_cmd_cc_proto localization_cc_proto
        planning_cc_proto preprocessor_cc_proto pipeline_cc_proto
        local_view_cc_proto
    COPTS -DMODULE_NAME="preprocessor_submodule"
)

apollo_cc_library(
    NAME lat_lon_controller_submodule_lib
    SRCS control_component/submodules/lat_lon_controller_submodule.cc
    HDRS control_component/submodules/lat_lon_controller_submodule.h
    DEPS
        cyber control_task_agent controllers_control_task_base_common
        control_gflags monitor_log
        control_cmd_cc_proto planning_cc_proto
        pipeline_cc_proto local_view_cc_proto
    COPTS -DMODULE_NAME="preprocessor_submodule"
)

apollo_cc_library(
    NAME mpc_controller_submodule_lib
    SRCS control_component/submodules/mpc_controller_submodule.cc
    HDRS control_component/submodules/mpc_controller_submodule.h
    DEPS
        cyber control_task_agent controllers_control_task_base_common
        control_gflags monitor_log
        control_cmd_cc_proto planning_cc_proto
        pipeline_cc_proto local_view_cc_proto
    COPTS -DMODULE_NAME="preprocessor_submodule"
)

apollo_cc_library(
    NAME postprocessor_submodule_lib
    SRCS control_component/submodules/postprocessor_submodule.cc
    HDRS control_component/submodules/postprocessor_submodule.h
    DEPS
        cyber control_task_agent controllers_control_task_base_common
        control_gflags monitor_log
        control_cmd_cc_proto planning_cc_proto
        pipeline_cc_proto local_view_cc_proto
    COPTS -DMODULE_NAME="preprocessor_submodule"
)

# ── apollo_control_lib (header-only, aggregates sub-modules) ──
apollo_cc_library(
    NAME apollo_control_lib
    DEPS
        cyber
        adapter_gflags
        monitor_log
        common_util
        chassis_cc_proto
        control_cmd_cc_proto
        control_interactive_msg_cc_proto
        control_pad_msg_cc_proto
        command_status_cc_proto
        localization_cc_proto
        planning_cc_proto
        pipeline_cc_proto
        preprocessor_cc_proto
        lat_lon_controller_submodule_lib
        mpc_controller_submodule_lib
        postprocessor_submodule_lib
        preprocessor_submodule_lib
        gflags
    COPTS -DMODULE_NAME="control"
)

# ── control_component ──
apollo_component(
    NAME libcontrol_component.so
    SRCS control_component/control_component.cc
    HDRS control_component/control_component.h
    DEPS
        apollo_control_lib
        control_task_agent
        controllers_control_task_base_common
    COPTS -DMODULE_NAME="control"
)

# ── control_task_base_extend common ──
apollo_cc_library(
    NAME control_checker
    SRCS control_task_base_extend/common/control_checker.cc
    HDRS control_task_base_extend/common/control_checker.h
    DEPS cyber control_gflags chassis_cc_proto control_cmd_cc_proto common_math eigen
    COPTS -DMODULE_NAME="control"
)

apollo_cc_library(
    NAME exponential_smoothing
    SRCS control_task_base_extend/common/exponential_smoothing.cc
    HDRS control_task_base_extend/common/exponential_smoothing.h
    COPTS -DMODULE_NAME="control"
)

apollo_cc_library(
    NAME interpolation_plus_1d
    SRCS control_task_base_extend/common/interpolation_plus_1d.cc
    HDRS control_task_base_extend/common/interpolation_plus_1d.h
    DEPS cyber eigen
    COPTS -DMODULE_NAME="control"
)

apollo_cc_library(
    NAME leadlag_plus_controller
    SRCS control_task_base_extend/common/leadlag_plus_controller.cc
    HDRS control_task_base_extend/common/leadlag_plus_controller.h
    DEPS cyber leadlag_conf_cc_proto
    COPTS -DMODULE_NAME="control"
)

apollo_cc_library(
    NAME math_utils
    SRCS control_task_base_extend/common/math_utils.cc
    HDRS control_task_base_extend/common/math_utils.h
    DEPS common_math
    COPTS -DMODULE_NAME="control"
)

apollo_cc_library(
    NAME pid_plus_controller
    SRCS control_task_base_extend/common/pid_plus_controller.cc
    HDRS control_task_base_extend/common/pid_plus_controller.h
    DEPS cyber pid_plus_conf_cc_proto
    COPTS -DMODULE_NAME="control"
)

apollo_cc_library(
    NAME trajectory_analyzer_extend
    SRCS control_task_base_extend/common/trajectory_analyzer_extend.cc
    HDRS control_task_base_extend/common/trajectory_analyzer_extend.h
    DEPS
        cyber trajectory_analyzer common_math
        pnc_point_cc_proto planning_cc_proto
        control_gflags eigen
    COPTS -DMODULE_NAME="control"
)

# ── control_task_extend ──
apollo_cc_library(
    NAME control_task_extend
    SRCS control_task_base_extend/control_task_extend.cc
    HDRS control_task_base_extend/control_task_extend.h
    DEPS
        control_task
        control_checker exponential_smoothing interpolation_plus_1d
        leadlag_plus_controller math_utils pid_plus_controller
        trajectory_analyzer_extend
        cyber status vehicle_config_helper
        control_debug_cc_proto
        planning_cc_proto control_cmd_cc_proto input_debug_cc_proto
        absl
    COPTS -DMODULE_NAME="control"
)

# ── Controller plugins ──
set(_CONTROLLER_PLUGINS
    debug_info_control_task
    demo_control_task
    lat_based_lqr_controller
    lat_based_lqr_plus_controller
    lon_based_pid_controller
    lon_based_pid_plus_controller
    mpc_controller
    replan_control_task
    slope_anti_slip_control_task
)

foreach(_ctrl ${_CONTROLLER_PLUGINS})
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/controllers/${_ctrl}")
        file(GLOB _ctrl_srcs "controllers/${_ctrl}/*.cc" "controllers/${_ctrl}/util/*.cc")
        list(FILTER _ctrl_srcs EXCLUDE REGEX ".*_test\\.cc$")
        file(GLOB _ctrl_hdrs "controllers/${_ctrl}/*.h" "controllers/${_ctrl}/util/*.h")

        # Read sub-protos if they exist
        set(_ctrl_proto_deps "")
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/controllers/${_ctrl}/proto")
            file(GLOB _ctrl_protos "controllers/${_ctrl}/proto/*.proto")
            foreach(_cp ${_ctrl_protos})
                get_filename_component(_cpn ${_cp} NAME_WE)
                apollo_proto_library(
                    NAME ctrl_${_ctrl}_${_cpn}_cc_proto
                    SRCS ${_cp}
                    DEPS
                        pid_conf_cc_proto leadlag_conf_cc_proto mrac_conf_cc_proto
                        gain_scheduler_conf_cc_proto calibration_table_cc_proto
                        check_status_cc_proto control_debug_cc_proto
                        pid_plus_conf_cc_proto params_pipeline_cc_proto
                        safety_check_conf_cc_proto
                )
                list(APPEND _ctrl_proto_deps ctrl_${_ctrl}_${_cpn}_cc_proto)
            endforeach()
        endif()

        if(_ctrl_srcs)
            apollo_plugin(
                NAME lib${_ctrl}.so
                SRCS ${_ctrl_srcs}
                HDRS ${_ctrl_hdrs}
                DEPS
                    control_task
                    control_task_extend
                    control_task_agent
                    controllers_control_task_base_common
                    control_gflags
                    cyber
                    common_math
                    status
                    vehicle_config_helper
                    control_cmd_cc_proto
                    control_debug_cc_proto
                    planning_cc_proto
                    chassis_cc_proto
                    vehicle_config_cc_proto
                    calibration_table_cc_proto
                    ${_ctrl_proto_deps}
                    eigen
                    absl
                    osqp
                COPTS -DMODULE_NAME="control"
            )
        endif()
    endif()
endforeach()
