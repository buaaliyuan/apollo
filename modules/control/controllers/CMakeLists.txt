# Build each controller as a separate shared library (plugin)

# lat_based_lqr_plus_controller
file(GLOB LAT_PLUS_SRCS 
    "lat_based_lqr_plus_controller/*.cc" 
    "lat_based_lqr_plus_controller/*.h"
    "lat_based_lqr_plus_controller/proto/*.cc"
    "lat_based_lqr_plus_controller/proto/*.h"
)
list(FILTER LAT_PLUS_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(lat_plus_controller SHARED ${LAT_PLUS_SRCS})
target_link_libraries(lat_plus_controller PUBLIC
    cyberrt
    common_msg
    common
    control_task_extend
    absl::strings
    gflags
    Eigen3::Eigen
)
set_target_properties(lat_plus_controller PROPERTIES POSITION_INDEPENDENT_CODE ON)

# lon_based_pid_plus_controller
file(GLOB LON_PLUS_SRCS 
    "lon_based_pid_plus_controller/*.cc" 
    "lon_based_pid_plus_controller/*.h"
    "lon_based_pid_plus_controller/proto/*.cc"
    "lon_based_pid_plus_controller/proto/*.h"
)
list(FILTER LON_PLUS_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(lon_plus_controller SHARED ${LON_PLUS_SRCS})
target_link_libraries(lon_plus_controller PUBLIC
    cyberrt
    common_msg
    common
    control_task_extend
    absl::strings
    gflags
)
set_target_properties(lon_plus_controller PROPERTIES POSITION_INDEPENDENT_CODE ON)

# demo_control_task
file(GLOB DEMO_SRCS 
    "demo_control_task/*.cc" 
    "demo_control_task/*.h"
    "demo_control_task/proto/*.cc"
    "demo_control_task/proto/*.h"
)
add_library(demo_control_task SHARED ${DEMO_SRCS})
target_link_libraries(demo_control_task PUBLIC
    cyberrt
    common_msg
    common
    absl::strings
    gflags
    Eigen3::Eigen
)
set_target_properties(demo_control_task PROPERTIES POSITION_INDEPENDENT_CODE ON)

# lat_based_lqr_controller
file(GLOB LAT_LQR_SRCS 
    "lat_based_lqr_controller/*.cc" 
    "lat_based_lqr_controller/*.h"
    "lat_based_lqr_controller/proto/*.cc"
    "lat_based_lqr_controller/proto/*.h"
)
list(FILTER LAT_LQR_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(lat_controller SHARED ${LAT_LQR_SRCS})
target_link_libraries(lat_controller PUBLIC
    cyberrt
    common_msg
    common
    absl::strings
    gflags
    Eigen3::Eigen
)
set_target_properties(lat_controller PROPERTIES POSITION_INDEPENDENT_CODE ON)

# lon_based_pid_controller
file(GLOB_RECURSE LON_PID_SRCS 
    "lon_based_pid_controller/*.cc" 
    "lon_based_pid_controller/*.h"
)
list(FILTER LON_PID_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(lon_controller SHARED ${LON_PID_SRCS})
target_link_libraries(lon_controller PUBLIC
    cyberrt
    common_msg
    common
    absl::strings
    gflags
)
set_target_properties(lon_controller PROPERTIES POSITION_INDEPENDENT_CODE ON)

# mpc_controller
file(GLOB MPC_SRCS 
    "mpc_controller/*.cc" 
    "mpc_controller/*.h"
    "mpc_controller/proto/*.cc"
    "mpc_controller/proto/*.h"
)
list(FILTER MPC_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(mpc_controller SHARED ${MPC_SRCS})
target_link_libraries(mpc_controller PUBLIC
    cyberrt
    common_msg
    common
    absl::strings
    gflags
    Eigen3::Eigen
)
set_target_properties(mpc_controller PROPERTIES POSITION_INDEPENDENT_CODE ON)

# debug_info_control_task
file(GLOB DEBUG_INFO_SRCS 
    "debug_info_control_task/*.cc" 
    "debug_info_control_task/*.h"
)
add_library(debug_info_control_task SHARED ${DEBUG_INFO_SRCS})
target_link_libraries(debug_info_control_task PUBLIC
    cyberrt
    common_msg
    common
    absl::strings
    gflags
)
set_target_properties(debug_info_control_task PROPERTIES POSITION_INDEPENDENT_CODE ON)

# replan_control_task
file(GLOB REPLAN_SRCS 
    "replan_control_task/*.cc" 
    "replan_control_task/*.h"
    "replan_control_task/proto/*.cc"
    "replan_control_task/proto/*.h"
)
add_library(replan_control_task SHARED ${REPLAN_SRCS})
target_link_libraries(replan_control_task PUBLIC
    cyberrt
    common_msg
    common
    absl::strings
    gflags
)
set_target_properties(replan_control_task PROPERTIES POSITION_INDEPENDENT_CODE ON)

# slope_anti_slip_control_task
file(GLOB ANTI_SLIP_SRCS 
    "slope_anti_slip_control_task/*.cc" 
    "slope_anti_slip_control_task/*.h"
    "slope_anti_slip_control_task/proto/*.cc"
    "slope_anti_slip_control_task/proto/*.h"
)
add_library(anti_slip_control_task SHARED ${ANTI_SLIP_SRCS})
target_link_libraries(anti_slip_control_task PUBLIC
    cyberrt
    common_msg
    common
    absl::strings
    gflags
)
set_target_properties(anti_slip_control_task PROPERTIES POSITION_INDEPENDENT_CODE ON)
