# dreamview_common library
file(GLOB_RECURSE COMMON_SRCS 
    "backend/common/*.cc"
    "backend/common/*.h"
    "backend/common/teleop/*.cc"
    "backend/common/teleop/*.h"
    "backend/common/**/proto/*.cc"
    "backend/common/**/proto/*.h"
)
list(FILTER COMMON_SRCS EXCLUDE REGEX ".*_test.cc$|.*vehicle_manager_main\\.cc$")

add_library(dreamview_common SHARED 
    ${COMMON_SRCS}
)
target_include_directories(dreamview_common PUBLIC
    ${OpenCV_INCLUDE_DIRS}
)
target_link_libraries(dreamview_common PUBLIC
    cyberrt
    common_msg
    common
    absl::strings
    gflags
    nlohmann_json
    yaml-cpp
    civetweb::civetweb
    ${OpenCV_LIBS}
)
set_target_properties(dreamview_common PROPERTIES POSITION_INDEPENDENT_CODE ON)

# dreamview_backend library
file(GLOB BACKEND_SRCS 
    "backend/dreamview.cc"
    "backend/dreamview.h"
    "backend/hmi/*.cc"
    "backend/hmi/*.h"
    "backend/perception_camera_updater/*.cc"
    "backend/perception_camera_updater/*.h"
    "backend/point_cloud/*.cc"
    "backend/point_cloud/*.h"
    "backend/teleop/*.cc"
    "backend/teleop/*.h"
    "backend/simulation_world/*.cc"
    "backend/simulation_world/*.h"
    "proto/*.cc"
    "proto/*.h"
)
list(FILTER BACKEND_SRCS EXCLUDE REGEX ".*_test.cc$")

add_library(dreamview_backend SHARED 
    ${BACKEND_SRCS}
)

target_link_libraries(dreamview_backend PUBLIC
    cyberrt
    common_msg
    common
    dreamview_common
    absl::strings
    gflags
    yaml-cpp
    nlohmann_json
    Eigen3::Eigen
)
set_target_properties(dreamview_backend PROPERTIES POSITION_INDEPENDENT_CODE ON)

# dreamview executable
add_executable(dreamview
    main.cc
)
target_link_libraries(dreamview PUBLIC
    dreamview_backend
    cyberrt
    gflags
)

# vehicle_manager_main executable
add_executable(vehicle_manager_main
    backend/common/vehicle_manager/vehicle_manager_main.cc
)
target_link_libraries(vehicle_manager_main PUBLIC
    dreamview_common
    cyberrt
    gflags
)
