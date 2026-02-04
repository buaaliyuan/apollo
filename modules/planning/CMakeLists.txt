set(PLANNING_COMMON_LIBS
	cyberrt
	common_msg
	common
	gflags
	absl::strings
    apollo_map
    absl::str_format
    PkgConfig::IPOPT_LIB
    PkgConfig::ADOLC_LIB
    osqp::osqp
)



# planning_base
file(GLOB_RECURSE PLANNING_BASE_SRCS
	"planning_base/*.cc"
	"planning_base/*.h"
)

list(FILTER PLANNING_BASE_SRCS EXCLUDE REGEX ".*_test.cc$|.*decision_data\\.(cc|h)$|learning_based/pipeline/evaluate_trajectory\\.cc$|learning_based/pipeline/record_to_learning_data\\.cc$|reference_line/smoother_util\\.cc$|reference_line/spiral_smoother_util\\.cc$|tools/pad_terminal\\.cc$|tools/inference_demo\\.cc$")

# 用到了planning里面的代码
list(APPEND PLANNING_BASE_SRCS
    ${PROJECT_SOURCE_DIR}/modules/prediction/proto/network_layers.pb.cc
    ${PROJECT_SOURCE_DIR}/modules/prediction/proto/network_model.pb.cc
)
add_library(apollo_planning_planning_base SHARED ${PLANNING_BASE_SRCS})
target_compile_definitions(apollo_planning_planning_base PRIVATE MODULE_NAME=\"planning\")
target_link_libraries(apollo_planning_planning_base 
PUBLIC 
    ${PLANNING_COMMON_LIBS} 
    ${OpenCV_LIBS}
    torch
    torch_cuda
    Boost::thread
    # add-rss-lib
)
target_include_directories(apollo_planning_planning_base 
PUBLIC 
    /usr/local/libtorch_gpu/include
    /usr/local/libtorch_gpu/include/torch/csrc/api/include/
    /apollo/thirdparty/install/include/ad_rss
)
target_link_directories(apollo_planning_planning_base
PUBLIC
    /usr/local/libtorch_gpu/lib
    /usr/lib/x86_64-linux-gnu/
)
set_target_properties(apollo_planning_planning_base PROPERTIES POSITION_INDEPENDENT_CODE ON)

# planning_interface_base
file(GLOB_RECURSE PLANNING_INTERFACE_BASE_SRCS
	"planning_interface_base/*.cc"
	"planning_interface_base/*.h"
)
#  里面有些文件编不过，本身bazel也没编
list(FILTER PLANNING_INTERFACE_BASE_SRCS EXCLUDE REGEX ".*_test.cc$|.*trajectory_cost\\.(cc|h)$|.*dp_road_graph\\.(cc|h)$|.*waypoint_sampler\\.(cc|h)$")
add_library(apollo_planning_planning_interface_base SHARED ${PLANNING_INTERFACE_BASE_SRCS})
target_compile_definitions(apollo_planning_planning_interface_base PRIVATE MODULE_NAME=\"planning\")
target_link_libraries(apollo_planning_planning_interface_base PUBLIC apollo_planning_planning_base ${PLANNING_COMMON_LIBS})
set_target_properties(apollo_planning_planning_interface_base PROPERTIES POSITION_INDEPENDENT_CODE ON)

# planning_open_space
file(GLOB_RECURSE PLANNING_OPEN_SPACE_SRCS
	"planning_open_space/*.cc"
	"planning_open_space/*.h"
)
list(FILTER PLANNING_OPEN_SPACE_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(apollo_planning_open_space SHARED ${PLANNING_OPEN_SPACE_SRCS})
target_compile_definitions(apollo_planning_open_space PRIVATE MODULE_NAME=\"planning\")
target_compile_options(apollo_planning_open_space PRIVATE -fopenmp)
target_link_libraries(apollo_planning_open_space PUBLIC apollo_planning_planning_base ${PLANNING_COMMON_LIBS} gomp)
set_target_properties(apollo_planning_open_space PROPERTIES POSITION_INDEPENDENT_CODE ON)

# planning_component
file(GLOB PLANNING_COMPONENT_SRCS
	"planning_component/*.cc"
	"planning_component/*.h"
)
list(FILTER PLANNING_COMPONENT_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(planning_component SHARED ${PLANNING_COMPONENT_SRCS})
target_compile_definitions(planning_component PRIVATE MODULE_NAME=\"planning\")
target_link_libraries(planning_component PUBLIC apollo_planning_planning_base apollo_planning_planning_interface_base ${PLANNING_COMMON_LIBS})
set_target_properties(planning_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# Planners (plugins)
file(GLOB_RECURSE LATTICE_PLANNER_SRCS "planners/lattice/*.cc" "planners/lattice/*.h")
list(FILTER LATTICE_PLANNER_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(lattice_planner SHARED ${LATTICE_PLANNER_SRCS})
target_compile_definitions(lattice_planner PRIVATE MODULE_NAME=\"planning\")
target_link_libraries(lattice_planner PUBLIC apollo_planning_planning_base apollo_planning_planning_interface_base ${PLANNING_COMMON_LIBS})
set_target_properties(lattice_planner PROPERTIES POSITION_INDEPENDENT_CODE ON)

file(GLOB_RECURSE NAVI_PLANNER_SRCS "planners/navi/*.cc" "planners/navi/*.h")
list(FILTER NAVI_PLANNER_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(navi_planner SHARED ${NAVI_PLANNER_SRCS})
target_compile_definitions(navi_planner PRIVATE MODULE_NAME=\"planning\")
target_link_libraries(navi_planner PUBLIC apollo_planning_planning_base apollo_planning_planning_interface_base ${PLANNING_COMMON_LIBS})
set_target_properties(navi_planner PROPERTIES POSITION_INDEPENDENT_CODE ON)

file(GLOB_RECURSE PUBLIC_ROAD_PLANNER_SRCS "planners/public_road/*.cc" "planners/public_road/*.h")
list(FILTER PUBLIC_ROAD_PLANNER_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(public_road_planner SHARED ${PUBLIC_ROAD_PLANNER_SRCS})
target_compile_definitions(public_road_planner PRIVATE MODULE_NAME=\"planning\")
target_link_libraries(public_road_planner PUBLIC apollo_planning_planning_base apollo_planning_planning_interface_base ${PLANNING_COMMON_LIBS})
set_target_properties(public_road_planner PROPERTIES POSITION_INDEPENDENT_CODE ON)

file(GLOB_RECURSE RTK_PLANNER_SRCS "planners/rtk/*.cc" "planners/rtk/*.h")
list(FILTER RTK_PLANNER_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(rtk_planner SHARED ${RTK_PLANNER_SRCS})
target_compile_definitions(rtk_planner PRIVATE MODULE_NAME=\"planning\")
target_link_libraries(rtk_planner PUBLIC apollo_planning_planning_base apollo_planning_planning_interface_base ${PLANNING_COMMON_LIBS})
set_target_properties(rtk_planner PROPERTIES POSITION_INDEPENDENT_CODE ON)

# Scenarios (plugins) - batch create all scenarios
file(GLOB SCENARIO_DIRS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/scenarios ${CMAKE_CURRENT_SOURCE_DIR}/scenarios/*)
foreach(SCENARIO_DIR ${SCENARIO_DIRS})
    if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/scenarios/${SCENARIO_DIR})
        file(GLOB_RECURSE SCENARIO_SRCS "scenarios/${SCENARIO_DIR}/*.cc" "scenarios/${SCENARIO_DIR}/*.h")
        list(FILTER SCENARIO_SRCS EXCLUDE REGEX ".*_test.cc$")
        if(SCENARIO_SRCS)
            add_library(${SCENARIO_DIR}_scenario SHARED ${SCENARIO_SRCS})
            target_compile_definitions(${SCENARIO_DIR}_scenario PRIVATE MODULE_NAME=\"planning\")
            target_link_libraries(${SCENARIO_DIR}_scenario PUBLIC apollo_planning_planning_base apollo_planning_planning_interface_base ${PLANNING_COMMON_LIBS})
            set_target_properties(${SCENARIO_DIR}_scenario PROPERTIES POSITION_INDEPENDENT_CODE ON)
        endif()
    endif()
endforeach()

# Tasks (plugins) - batch create all tasks
file(GLOB TASK_DIRS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/tasks ${CMAKE_CURRENT_SOURCE_DIR}/tasks/*)
foreach(TASK_DIR ${TASK_DIRS})
    if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/tasks/${TASK_DIR})
        file(GLOB_RECURSE TASK_SRCS "tasks/${TASK_DIR}/*.cc" "tasks/${TASK_DIR}/*.h")
        list(FILTER TASK_SRCS EXCLUDE REGEX ".*_test.cc$")
        if(TASK_SRCS)
            add_library(${TASK_DIR}_task SHARED ${TASK_SRCS})
            target_compile_definitions(${TASK_DIR}_task PRIVATE MODULE_NAME=\"planning\")
            target_compile_options(${TASK_DIR}_task PRIVATE -fopenmp)
            target_link_libraries(${TASK_DIR}_task PUBLIC apollo_planning_planning_base apollo_planning_planning_interface_base apollo_planning_open_space ${PLANNING_COMMON_LIBS} gomp)
            set_target_properties(${TASK_DIR}_task PROPERTIES POSITION_INDEPENDENT_CODE ON)
        endif()
    endif()
endforeach()

# Traffic Rules (plugins) - batch create all traffic rules
file(GLOB TRAFFIC_RULE_DIRS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/traffic_rules ${CMAKE_CURRENT_SOURCE_DIR}/traffic_rules/*)
foreach(RULE_DIR ${TRAFFIC_RULE_DIRS})
    if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/traffic_rules/${RULE_DIR})
        file(GLOB_RECURSE RULE_SRCS "traffic_rules/${RULE_DIR}/*.cc" "traffic_rules/${RULE_DIR}/*.h")
        list(FILTER RULE_SRCS EXCLUDE REGEX ".*_test.cc$")
        if(RULE_SRCS)
            add_library(${RULE_DIR}_traffic_rule SHARED ${RULE_SRCS})
            target_compile_definitions(${RULE_DIR}_traffic_rule PRIVATE MODULE_NAME=\"planning\")
            target_link_libraries(${RULE_DIR}_traffic_rule PUBLIC apollo_planning_planning_base apollo_planning_planning_interface_base ${PLANNING_COMMON_LIBS})
            set_target_properties(${RULE_DIR}_traffic_rule PROPERTIES POSITION_INDEPENDENT_CODE ON)
        endif()
    endif()
endforeach()

# Binary executables in planning_base
add_executable(evaluate_trajectory planning_base/learning_based/pipeline/evaluate_trajectory.cc)
target_compile_definitions(evaluate_trajectory PRIVATE MODULE_NAME=\"planning\")
target_link_libraries(evaluate_trajectory apollo_planning_planning_base ${PLANNING_COMMON_LIBS})

add_executable(record_to_learning_data planning_base/learning_based/pipeline/record_to_learning_data.cc)
target_compile_definitions(record_to_learning_data PRIVATE MODULE_NAME=\"planning\")
target_link_libraries(record_to_learning_data apollo_planning_planning_base ${PLANNING_COMMON_LIBS})

add_executable(smoother_util planning_base/reference_line/smoother_util.cc)
target_compile_definitions(smoother_util PRIVATE MODULE_NAME=\"planning\")
target_link_libraries(smoother_util 
    apollo_planning_planning_base 
    ${PLANNING_COMMON_LIBS}
)

add_executable(spiral_smoother_util planning_base/reference_line/spiral_smoother_util.cc)
target_compile_definitions(spiral_smoother_util PRIVATE MODULE_NAME=\"planning\")
target_link_libraries(spiral_smoother_util apollo_planning_planning_base ${PLANNING_COMMON_LIBS})

add_executable(planning_pad_terminal planning_base/tools/pad_terminal.cc)
target_compile_definitions(planning_pad_terminal PRIVATE MODULE_NAME=\"planning\")
target_link_libraries(planning_pad_terminal apollo_planning_planning_base ${PLANNING_COMMON_LIBS})

add_executable(inference_demo planning_base/tools/inference_demo.cc)
target_compile_definitions(inference_demo PRIVATE MODULE_NAME=\"planning\")
target_link_libraries(inference_demo gflags torch)
