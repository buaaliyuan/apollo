# smart_recorder library
file(GLOB SMART_RECORDER_SRCS 
    "tools/smart_recorder/*.cc"
    "tools/smart_recorder/*.h"
    "tools/smart_recorder/proto/*.cc"
    "tools/smart_recorder/proto/*.h"
    "proto/*.cc"
    "proto/*.h"
)
# list(FILTER SMART_RECORDER_SRCS EXCLUDE REGEX ".*smart_recorder\\.cc$")

add_library(smart_recorder_lib SHARED 
    ${SMART_RECORDER_SRCS}
    ${PROJECT_SOURCE_DIR}/cyber/proto/record.pb.cc
    ${PROJECT_SOURCE_DIR}/cyber/proto/record.pb.h
    ${PROJECT_SOURCE_DIR}/cyber/tools/cyber_recorder/recorder.cc #依赖recorder api
    ${PROJECT_SOURCE_DIR}/modules/dreamview/backend/common/dreamview_gflags.cc
    ${PROJECT_SOURCE_DIR}/modules/dreamview/backend/common/util/hmi_util.cc
    ${PROJECT_SOURCE_DIR}/modules/monitor/common/monitor_manager.cc
    ${PROJECT_SOURCE_DIR}/modules/canbus/proto/canbus_conf.pb.cc
    ${PROJECT_SOURCE_DIR}/modules/canbus/proto/canbus_conf.pb.h
    ${PROJECT_SOURCE_DIR}/modules/canbus/proto/vehicle_parameter.pb.cc
    ${PROJECT_SOURCE_DIR}/modules/canbus/proto/vehicle_parameter.pb.h
)

target_link_libraries(smart_recorder_lib PUBLIC
    cyberrt
    common_msg
    common
    absl::strings
    gflags
)
set_target_properties(smart_recorder_lib PROPERTIES POSITION_INDEPENDENT_CODE ON)

# smart_recorder executable
add_executable(smart_recorder
    tools/smart_recorder/smart_recorder.cc
)
target_link_libraries(smart_recorder PUBLIC
    smart_recorder_lib
    cyberrt
    common_msg
    common
    gflags
)
