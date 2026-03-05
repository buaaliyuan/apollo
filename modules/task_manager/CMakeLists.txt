file(GLOB_RECURSE MODULES_SRC_FILES
    "${CMAKE_CURRENT_SOURCE_DIR}/*.cc"
)

list(FILTER MODULES_SRC_FILES EXCLUDE REGEX ".*_test.cc$")

add_library(task_manager_component SHARED ${MODULES_SRC_FILES})
target_link_libraries(task_manager_component 
PRIVATE
    cyber
    msg_proto
    modules_common
)
install(TARGETS task_manager_component
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)