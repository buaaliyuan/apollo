add_library(debug_info_control_task SHARED
    debug_info_control_task/debug_info_control_task.cc
)
target_link_libraries(debug_info_control_task PUBLIC
    cyber
    control_component
    control_task_extend
)

add_library(demo_control_task SHARED
    demo_control_task/demo_control_task.cc
    demo_control_task/proto/demo_control_task_conf.pb.cc
)
target_link_libraries(demo_control_task PUBLIC
    cyber
    control_component
    control_task_extend
)

add_library(lat_based_lqr_controller SHARED
    lat_based_lqr_controller/lat_controller.cc
    lat_based_lqr_controller/proto/lat_based_lqr_controller_conf.pb.cc
)
target_link_libraries(lat_based_lqr_controller PUBLIC
    cyber
    control_component
    control_task_extend
)

add_library(lat_based_lqr_plus_controller SHARED
    lat_based_lqr_plus_controller/lat_plus_controller.cc
    lat_based_lqr_plus_controller/proto/lat_based_lqr_plus_controller_conf.pb.cc
)
target_link_libraries(lat_based_lqr_plus_controller PUBLIC
    cyber
    control_component
    control_task_extend
)

add_library(lon_based_pid_controller SHARED
    lon_based_pid_controller/lon_controller.cc
    lon_based_pid_controller/proto/lon_based_pid_controller_conf.pb.cc
    lon_based_pid_controller/util/check_pit.cc
)
target_link_libraries(lon_based_pid_controller PUBLIC
    cyber
    control_component
    control_task_extend
)

add_library(lon_based_pid_plus_controller SHARED
    lon_based_pid_plus_controller/lon_plus_controller.cc
    lon_based_pid_plus_controller/proto/lon_based_pid_plus_controller_conf.pb.cc
)
target_link_libraries(lon_based_pid_plus_controller PUBLIC
    cyber
    control_component
    control_task_extend
)

add_library(mpc_controller SHARED
    mpc_controller/mpc_controller.cc
    mpc_controller/proto/mpc_controller.pb.cc
)
target_link_libraries(mpc_controller PUBLIC
    cyber
    control_component
    control_task_extend
    osqp
)

add_library(replan_control_task SHARED
    replan_control_task/replan_control_task.cc
    replan_control_task/proto/replan_task_conf.pb.cc
)
target_link_libraries(replan_control_task PUBLIC
    cyber
    control_component
    control_task_extend
)

add_library(slope_anti_slip_control_task SHARED
    slope_anti_slip_control_task/anti_slip_control_task.cc
    slope_anti_slip_control_task/proto/antislip_control_task_conf.pb.cc
)
target_link_libraries(slope_anti_slip_control_task PUBLIC
    cyber
    control_component
    control_task_extend
)

install(TARGETS debug_info_control_task demo_control_task lat_based_lqr_controller lat_based_lqr_plus_controller lon_based_pid_controller lon_based_pid_plus_controller mpc_controller replan_control_task slope_anti_slip_control_task
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)