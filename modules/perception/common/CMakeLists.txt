file(GLOB_RECURSE CCS "${CMAKE_CURRENT_SOURCE_DIR}/*.cc" "${CMAKE_CURRENT_SOURCE_DIR}/*.cu")
list(FILTER CCS EXCLUDE REGEX ".*_test.cc$")
list(FILTER CCS EXCLUDE REGEX ".*migraphx.*") #排除掉migraphx相关文件

# 过滤掉含有main函数的文件，避免被误编译成库的一部分
foreach(f ${CCS})
    file(READ "${f}" _file_content)
    if(_file_content MATCHES "int[  \t\r\n]+main[  \t\r\n]*\\(")
        list(REMOVE_ITEM CCS "${f}")
        message(STATUS "Filtered out (contains main): ${f}")
    endif()
endforeach()


message(STATUS "===== ${CUDA_INCLUDE_DIRS} =====")

add_library(perception_common SHARED ${CCS})
target_include_directories(perception_common
PUBLIC
    ${OpenCV_INCLUDE_DIRS}
    ${CUDA_INCLUDE_DIRS}
    ${TORCH_INCLUDE_DIRS}
)
target_link_libraries(perception_common
PUBLIC
    cyber
    msg_proto
    modules_common
    ${OpenCV_LIBS}
    paddle_inference
    tf2
    Eigen3::Eigen
    yaml-cpp
    ${TORCH_LIBRARIES}
    apollo_map
    Boost::thread
)

target_compile_definitions(perception_common
PUBLIC
    MODULE_NAME="perception"
)

# 启用SSE4.1指令集支持
target_compile_options(perception_common
PRIVATE
    -msse4.1
)

set_target_properties(perception_common PROPERTIES
    CUDA_ARCHITECTURES "80;86" 
)

install(TARGETS perception_common
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)