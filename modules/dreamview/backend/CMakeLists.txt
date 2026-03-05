file(GLOB_RECURSE MODULES_SRC_FILES
    "${CMAKE_CURRENT_SOURCE_DIR}/*.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/*.h"
)

list(FILTER MODULES_SRC_FILES EXCLUDE REGEX ".*_test.cc$")
list(FILTER MODULES_SRC_FILES EXCLUDE REGEX ".*teleop/teleop\\.cc$|.*vehicle_manager_main.cc$")
target_sources(dreamview_backend PRIVATE ${MODULES_SRC_FILES})
target_link_libraries(dreamview_backend 
PUBLIC
    cyber
    msg_proto
    civetweb
    Eigen3::Eigen
    tf2
    pcl
    ${OpenCV_LIBS}
    modules_common
    sqlite3
    apollo_map
    Boost::thread
    yaml-cpp
    static_transform_component
    Boost::filesystem
)