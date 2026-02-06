# ============================================================================
# modules/planning/CMakeLists.txt
# ============================================================================

# ── Proto (planning_base/proto/) ──
apollo_proto_library(
    NAME st_drivable_boundary_cc_proto
    SRCS planning_base/proto/st_drivable_boundary.proto
)

apollo_proto_library(
    NAME planning_semantic_map_config_cc_proto
    SRCS planning_base/proto/planning_semantic_map_config.proto
)

apollo_proto_library(
    NAME lattice_structure_cc_proto
    SRCS planning_base/proto/lattice_structure.proto
)

apollo_proto_library(
    NAME auto_tuning_model_input_cc_proto
    SRCS planning_base/proto/auto_tuning_model_input.proto
)

apollo_proto_library(
    NAME ipopt_return_status_cc_proto
    SRCS planning_base/proto/ipopt_return_status.proto
)

apollo_proto_library(
    NAME piecewise_jerk_path_config_cc_proto
    SRCS planning_base/proto/piecewise_jerk_path_config.proto
)

apollo_proto_library(
    NAME plugin_declare_info_cc_proto
    SRCS planning_base/proto/plugin_declare_info.proto
)

apollo_proto_library(
    NAME planning_config_cc_proto
    SRCS planning_base/proto/planning_config.proto
    DEPS plugin_declare_info_cc_proto
)

# ── Proto (planning_base/proto/math/) ── (must be before reference_line_smoother_config)
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/planning_base/proto/math")
    file(GLOB _math_protos planning_base/proto/math/*.proto)
    foreach(_p ${_math_protos})
        get_filename_component(_pn ${_p} NAME_WE)
        apollo_proto_library(
            NAME planning_math_${_pn}_cc_proto
            SRCS ${_p}
        )
    endforeach()
endif()

apollo_proto_library(
    NAME reference_line_smoother_config_cc_proto
    SRCS planning_base/proto/reference_line_smoother_config.proto
    DEPS planning_math_cos_theta_smoother_config_cc_proto
         planning_math_fem_pos_deviation_smoother_config_cc_proto
)

apollo_proto_library(
    NAME auto_tuning_raw_feature_cc_proto
    SRCS planning_base/proto/auto_tuning_raw_feature.proto
    DEPS pnc_point_cc_proto auto_tuning_model_input_cc_proto
)

apollo_proto_library(
    NAME planning_status_cc_proto
    SRCS planning_base/proto/planning_status.proto
    DEPS geometry_cc_proto routing_cc_proto map_id_cc_proto
         lane_follow_command_cc_proto
)

apollo_proto_library(
    NAME learning_data_cc_proto
    SRCS planning_base/proto/learning_data.proto
    DEPS header_cc_proto geometry_cc_proto pnc_point_cc_proto
         map_lane_cc_proto
         perception_obstacle_cc_proto traffic_light_detection_cc_proto
         feature_cc_proto prediction_obstacle_cc_proto
         routing_cc_proto routing_geometry_cc_proto
         planning_cc_proto chassis_cc_proto
)

# ── Proto (planning_base/learning_based/model_inference/proto/) ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/planning_base/learning_based/model_inference/proto")
    file(GLOB _lm_protos planning_base/learning_based/model_inference/proto/*.proto)
    foreach(_p ${_lm_protos})
        get_filename_component(_pn ${_p} NAME_WE)
        apollo_proto_library(
            NAME planning_learning_${_pn}_cc_proto
            SRCS ${_p}
        )
    endforeach()
endif()

# Collect all planning_base proto targets as deps for sub-module protos
set(_PLANNING_BASE_PROTO_DEPS
    st_drivable_boundary_cc_proto
    planning_semantic_map_config_cc_proto
    lattice_structure_cc_proto
    auto_tuning_model_input_cc_proto
    ipopt_return_status_cc_proto
    piecewise_jerk_path_config_cc_proto
    plugin_declare_info_cc_proto
    planning_config_cc_proto
    reference_line_smoother_config_cc_proto
    auto_tuning_raw_feature_cc_proto
    planning_status_cc_proto
    learning_data_cc_proto
)
# Add math proto deps
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/planning_base/proto/math")
    file(GLOB _mpp planning_base/proto/math/*.proto)
    foreach(_mp ${_mpp})
        get_filename_component(_mpn ${_mp} NAME_WE)
        list(APPEND _PLANNING_BASE_PROTO_DEPS planning_math_${_mpn}_cc_proto)
    endforeach()
endif()

# ── Proto (planning_interface_base/) ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/planning_interface_base/scenario_base/proto")
    file(GLOB _pib_protos planning_interface_base/scenario_base/proto/*.proto)
    foreach(_p ${_pib_protos})
        get_filename_component(_pn ${_p} NAME_WE)
        apollo_proto_library(
            NAME planning_ib_${_pn}_cc_proto
            SRCS ${_p}
            DEPS ${_PLANNING_BASE_PROTO_DEPS}
        )
    endforeach()
endif()

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/planning_interface_base/traffic_rules_base/proto")
    file(GLOB _tr_protos planning_interface_base/traffic_rules_base/proto/*.proto)
    foreach(_p ${_tr_protos})
        get_filename_component(_pn ${_p} NAME_WE)
        apollo_proto_library(
            NAME planning_tr_${_pn}_cc_proto
            SRCS ${_p}
            DEPS ${_PLANNING_BASE_PROTO_DEPS}
        )
    endforeach()
endif()

# ── Proto (planning_open_space/proto/) ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/planning_open_space/proto")
    file(GLOB _os_protos planning_open_space/proto/*.proto)
    foreach(_p ${_os_protos})
        get_filename_component(_pn ${_p} NAME_WE)
        apollo_proto_library(
            NAME planning_os_${_pn}_cc_proto
            SRCS ${_p}
            DEPS ${_PLANNING_BASE_PROTO_DEPS}
        )
    endforeach()
endif()

# ── planning_base library (the core) ──
file(GLOB_RECURSE _planning_base_srcs planning_base/*.cc)
list(FILTER _planning_base_srcs EXCLUDE REGEX ".*_test\\.cc$")
# Remove binary tools
list(FILTER _planning_base_srcs EXCLUDE REGEX ".*smoother_util\\.cc$")
list(FILTER _planning_base_srcs EXCLUDE REGEX ".*spiral_smoother_util\\.cc$")
list(FILTER _planning_base_srcs EXCLUDE REGEX ".*evaluate_trajectory\\.cc$")
list(FILTER _planning_base_srcs EXCLUDE REGEX ".*record_to_learning_data\\.cc$")
list(FILTER _planning_base_srcs EXCLUDE REGEX ".*pad_terminal\\.cc$")
list(FILTER _planning_base_srcs EXCLUDE REGEX ".*inference_demo\\.cc$")
# Remove decision_data.cc (API mismatch with current Obstacle class)
list(FILTER _planning_base_srcs EXCLUDE REGEX ".*decision_data\\.cc$")
# Remove proto .cc (handled by proto_library)
list(FILTER _planning_base_srcs EXCLUDE REGEX ".*\\.pb\\.cc$")
# Remove libtorch/opencv learning_based files when torch not available
if(NOT _torch_lib)
    list(FILTER _planning_base_srcs EXCLUDE REGEX ".*trajectory_imitation_libtorch_inference\\.cc$")
    list(FILTER _planning_base_srcs EXCLUDE REGEX ".*birdview_img_feature_renderer\\.cc$")
endif()

apollo_cc_library(
    NAME apollo_planning_planning_base
    SRCS ${_planning_base_srcs}
    DEPS
        cyber
        adapter_gflags
        config_gflags
        vehicle_config_helper
        common_math
        qp_solver
        monitor_log
        status
        common_util
        util_tool
        vehicle_model
        vehicle_state_provider
        apollo_map
        apollo_prediction_network
        # Proto deps
        planning_cc_proto
        planning_command_cc_proto
        planning_config_cc_proto
        planning_status_cc_proto
        learning_data_cc_proto
        lattice_structure_cc_proto
        st_drivable_boundary_cc_proto
        auto_tuning_raw_feature_cc_proto
        auto_tuning_model_input_cc_proto
        reference_line_smoother_config_cc_proto
        ipopt_return_status_cc_proto
        planning_semantic_map_config_cc_proto
        pnc_point_cc_proto
        geometry_cc_proto
        routing_cc_proto
        localization_cc_proto
        perception_obstacle_cc_proto
        traffic_light_detection_cc_proto
        prediction_obstacle_cc_proto
        chassis_cc_proto
        map_lane_cc_proto
        map_id_cc_proto
        control_interactive_msg_cc_proto
        # Third party
        Boost::filesystem
        gflags
        absl
        protobuf::libprotobuf
        eigen
        ipopt
        osqp
        ${OpenCV_LIBS}
    COPTS -DMODULE_NAME="planning" -fopenmp
    LINKOPTS -lgomp
)

# ── planning_interface_base library ──
file(GLOB_RECURSE _planning_ib_srcs planning_interface_base/*.cc)
list(FILTER _planning_ib_srcs EXCLUDE REGEX ".*_test\\.cc$")
list(FILTER _planning_ib_srcs EXCLUDE REGEX ".*\\.pb\\.cc$")
# road_graph references non-existent dp_poly_path_config.proto (deprecated)
list(FILTER _planning_ib_srcs EXCLUDE REGEX ".*/road_graph/.*\\.cc$")

# Collect all planning_ib proto targets
set(_pib_proto_deps "")
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/planning_interface_base/scenario_base/proto")
    file(GLOB _pib_pf planning_interface_base/scenario_base/proto/*.proto)
    foreach(_pf ${_pib_pf})
        get_filename_component(_pfn ${_pf} NAME_WE)
        list(APPEND _pib_proto_deps planning_ib_${_pfn}_cc_proto)
    endforeach()
endif()
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/planning_interface_base/traffic_rules_base/proto")
    file(GLOB _tr_pf planning_interface_base/traffic_rules_base/proto/*.proto)
    foreach(_pf ${_tr_pf})
        get_filename_component(_pfn ${_pf} NAME_WE)
        list(APPEND _pib_proto_deps planning_tr_${_pfn}_cc_proto)
    endforeach()
endif()

apollo_cc_library(
    NAME apollo_planning_planning_interface_base
    SRCS ${_planning_ib_srcs}
    DEPS
        cyber
        apollo_planning_planning_base
        ${_pib_proto_deps}
    COPTS -DMODULE_NAME="planning"
)

# ── planning_open_space library ──
file(GLOB_RECURSE _planning_os_srcs planning_open_space/*.cc)
list(FILTER _planning_os_srcs EXCLUDE REGEX ".*_test\\.cc$")
# Remove CUDA files if no GPU
if(NOT APOLLO_USE_GPU)
    list(FILTER _planning_os_srcs EXCLUDE REGEX ".*_cuda.*\\.cc$")
endif()
# Remove wrapper binaries
list(FILTER _planning_os_srcs EXCLUDE REGEX ".*_wrapper\\.cc$")
list(FILTER _planning_os_srcs EXCLUDE REGEX ".*\\.pb\\.cc$")

set(_os_proto_deps "")
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/planning_open_space/proto")
    file(GLOB _os_pf planning_open_space/proto/*.proto)
    foreach(_pf ${_os_pf})
        get_filename_component(_pfn ${_pf} NAME_WE)
        list(APPEND _os_proto_deps planning_os_${_pfn}_cc_proto)
    endforeach()
endif()

apollo_cc_library(
    NAME apollo_planning_open_space
    SRCS ${_planning_os_srcs}
    DEPS
        cyber
        apollo_planning_planning_base
        ${_os_proto_deps}
        ipopt
        osqp
        eigen
    COPTS -DMODULE_NAME="planning" -fopenmp
    LINKOPTS -lgomp
)

# ── park_data_center library ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/park_data_center")
    file(GLOB_RECURSE _pdc_srcs park_data_center/*.cc)
    list(FILTER _pdc_srcs EXCLUDE REGEX ".*_test\\.cc$")
    apollo_cc_library(
        NAME apollo_park_data_center
        SRCS ${_pdc_srcs}
        DEPS
            cyber
            common_math
            common_util
            error_code_cc_proto
            pnc_point_cc_proto
            apollo_planning_planning_base
            gflags
        COPTS -DMODULE_NAME="planning" -fopenmp
        LINKOPTS -lgomp
    )
endif()

# ── pnc_map ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/pnc_map")
    file(GLOB_RECURSE _pnc_map_srcs pnc_map/*.cc)
    list(FILTER _pnc_map_srcs EXCLUDE REGEX ".*_test\\.cc$")
    if(_pnc_map_srcs)
        apollo_cc_library(
            NAME apollo_planning_pnc_map
            SRCS ${_pnc_map_srcs}
            DEPS
                apollo_planning_planning_base
                apollo_map
                cyber
            COPTS -DMODULE_NAME="planning"
        )
    endif()
endif()

# ── Planners (each is a plugin) ──
set(_PLANNER_DIRS lattice navi public_road rtk)
foreach(_planner ${_PLANNER_DIRS})
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/planners/${_planner}")
        file(GLOB_RECURSE _planner_srcs "planners/${_planner}/*.cc")
        list(FILTER _planner_srcs EXCLUDE REGEX ".*_test\\.cc$")
        if(_planner_srcs)
            # Read planner protos if any
            set(_planner_proto_deps "")
            if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/planners/${_planner}/proto")
                file(GLOB _pp planners/${_planner}/proto/*.proto)
                # First pass: create all proto targets
                foreach(_pf ${_pp})
                    get_filename_component(_pfn ${_pf} NAME_WE)
                    apollo_proto_library(
                        NAME planner_${_planner}_${_pfn}_cc_proto
                        SRCS ${_pf}
                        DEPS ${_PLANNING_BASE_PROTO_DEPS}
                    )
                    list(APPEND _planner_proto_deps planner_${_planner}_${_pfn}_cc_proto)
                endforeach()
                # Second pass: parse intra-directory imports and add one-directional deps
                foreach(_pf ${_pp})
                    get_filename_component(_pfn ${_pf} NAME_WE)
                    set(_this_target planner_${_planner}_${_pfn}_cc_proto)
                    # Read the proto file and find intra-directory imports
                    file(READ ${_pf} _proto_content)
                    foreach(_other_pf ${_pp})
                        if(NOT "${_other_pf}" STREQUAL "${_pf}")
                            get_filename_component(_other_pfn ${_other_pf} NAME_WE)
                            # Check if this proto imports the other
                            string(FIND "${_proto_content}" "${_other_pfn}.proto" _import_pos)
                            if(NOT _import_pos EQUAL -1)
                                add_dependencies(${_this_target} planner_${_planner}_${_other_pfn}_cc_proto)
                            endif()
                        endif()
                    endforeach()
                endforeach()
            endif()

            apollo_plugin(
                NAME lib${_planner}_planner.so
                SRCS ${_planner_srcs}
                DEPS
                    apollo_planning_planning_base
                    apollo_planning_planning_interface_base
                    apollo_planning_open_space
                    cyber
                    ${_planner_proto_deps}
                    osqp
                    eigen
                COPTS -DMODULE_NAME="planning"
            )
        endif()
    endif()
endforeach()

# ── Scenarios (each is a plugin) ──
file(GLOB _scenario_dirs RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/scenarios" "scenarios/*")
foreach(_scenario ${_scenario_dirs})
    if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/scenarios/${_scenario}")
        file(GLOB_RECURSE _sc_srcs "scenarios/${_scenario}/*.cc")
        list(FILTER _sc_srcs EXCLUDE REGEX ".*_test\\.cc$")

        set(_sc_proto_deps "")
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/scenarios/${_scenario}/proto")
            file(GLOB _sp "scenarios/${_scenario}/proto/*.proto")
            foreach(_pf ${_sp})
                get_filename_component(_pfn ${_pf} NAME_WE)
                apollo_proto_library(
                    NAME scenario_${_scenario}_${_pfn}_cc_proto
                    SRCS ${_pf}
                    DEPS ${_PLANNING_BASE_PROTO_DEPS}
                )
                list(APPEND _sc_proto_deps scenario_${_scenario}_${_pfn}_cc_proto)
            endforeach()
        endif()

        if(_sc_srcs)
            apollo_plugin(
                NAME libscenario_${_scenario}.so
                SRCS ${_sc_srcs}
                DEPS
                    apollo_planning_planning_base
                    apollo_planning_planning_interface_base
                    apollo_planning_open_space
                    cyber
                    ${_sc_proto_deps}
                COPTS -DMODULE_NAME="planning"
            )
        endif()
    endif()
endforeach()

# ── Tasks (each is a plugin) ──
file(GLOB _task_dirs RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/tasks" "tasks/*")
# Exclude tasks requiring unavailable libraries
list(REMOVE_ITEM _task_dirs "rss_decider")
foreach(_task ${_task_dirs})
    if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/tasks/${_task}")
        file(GLOB_RECURSE _tk_srcs "tasks/${_task}/*.cc")
        list(FILTER _tk_srcs EXCLUDE REGEX ".*_test\\.cc$")

        set(_tk_proto_deps "")
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/tasks/${_task}/proto")
            file(GLOB _tp "tasks/${_task}/proto/*.proto")
            foreach(_pf ${_tp})
                get_filename_component(_pfn ${_pf} NAME_WE)
                apollo_proto_library(
                    NAME task_${_task}_${_pfn}_cc_proto
                    SRCS ${_pf}
                    DEPS ${_PLANNING_BASE_PROTO_DEPS}
                )
                list(APPEND _tk_proto_deps task_${_task}_${_pfn}_cc_proto)
            endforeach()
        endif()

        if(_tk_srcs)
            apollo_plugin(
                NAME libtask_${_task}.so
                SRCS ${_tk_srcs}
                DEPS
                    apollo_planning_planning_base
                    apollo_planning_planning_interface_base
                    apollo_planning_open_space
                    cyber
                    ${_tk_proto_deps}
                    osqp
                    ipopt
                    eigen
                COPTS -DMODULE_NAME="planning" -fopenmp
            )
        endif()
    endif()
endforeach()

# ── Traffic rules (each is a plugin) ──
file(GLOB _tr_dirs RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/traffic_rules" "traffic_rules/*")
foreach(_tr ${_tr_dirs})
    if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/traffic_rules/${_tr}")
        file(GLOB_RECURSE _tr_srcs "traffic_rules/${_tr}/*.cc")
        list(FILTER _tr_srcs EXCLUDE REGEX ".*_test\\.cc$")

        set(_trf_proto_deps "")
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/traffic_rules/${_tr}/proto")
            file(GLOB _trp "traffic_rules/${_tr}/proto/*.proto")
            foreach(_pf ${_trp})
                get_filename_component(_pfn ${_pf} NAME_WE)
                apollo_proto_library(
                    NAME traffic_rule_${_tr}_${_pfn}_cc_proto
                    SRCS ${_pf}
                    DEPS ${_PLANNING_BASE_PROTO_DEPS}
                )
                list(APPEND _trf_proto_deps traffic_rule_${_tr}_${_pfn}_cc_proto)
            endforeach()
        endif()

        if(_tr_srcs)
            apollo_plugin(
                NAME libtraffic_rule_${_tr}.so
                SRCS ${_tr_srcs}
                DEPS
                    apollo_planning_planning_base
                    apollo_planning_planning_interface_base
                    cyber
                    ${_trf_proto_deps}
                COPTS -DMODULE_NAME="planning"
            )
        endif()
    endif()
endforeach()

# ── planning_component ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/planning_component/planning_component.cc")
    apollo_component(
        NAME libplanning_component.so
        SRCS
            planning_component/planning_component.cc
            planning_component/navi_planning.cc
            planning_component/on_lane_planning.cc
            planning_component/planning_base.cc
        HDRS
            planning_component/planning_component.h
            planning_component/navi_planning.h
            planning_component/on_lane_planning.h
            planning_component/planning_base.h
        DEPS
            apollo_planning_planning_base
            apollo_planning_planning_interface_base
            lane_follow_command_cc_proto
            command_status_cc_proto
            control_interactive_msg_cc_proto
            cyber
        COPTS -DMODULE_NAME="planning"
    )
endif()
