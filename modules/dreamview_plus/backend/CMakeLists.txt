file(GLOB_RECURSE SRC_FILES
    "${CMAKE_CURRENT_SOURCE_DIR}/*.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/*.h"
)

list(FILTER SRC_FILES EXCLUDE REGEX ".*_test.cc$")
list(FILTER SRC_FILES EXCLUDE REGEX ".*teleop/teleop\\.cc$|.*vehicle_manager_main.cc$")
target_sources(dreamview_plus PRIVATE ${SRC_FILES})