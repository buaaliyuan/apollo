file(GLOB_RECURSE PLANNING_BASE_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER PLANNING_BASE_SOURCES EXCLUDE REGEX ".*_test\\.cc$")
list(FILTER PLANNING_BASE_SOURCES EXCLUDE REGEX "decision_data.cc|record_to_learning_data.cc|evaluate_trajectory.cc|spiral_smoother_util.cc|inference_demo.cc|smoother_util.cc") #这个文件好像没用到

add_library(planning_base SHARED ${PLANNING_BASE_SOURCES})

target_link_libraries(planning_base PUBLIC
    cyber
    Eigen3::Eigen
    Boost::thread
    Boost::system
    gtest_headers
    ${TORCH_LIBRARIES}
    ${OpenCV_LIBS}
)

target_include_directories(planning_base PUBLIC
    ${OpenCV_INCLUDE_DIRS}
    ${CUDA_INCLUDE_DIRS}
    ${TORCH_INCLUDE_DIRS}
    ${PYTHON_INCLUDE_DIRS}
)