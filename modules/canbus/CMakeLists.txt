add_library(canbus_component MODULE
    canbus_component.cc
    canbus_component.h
    common/canbus_gflags.cc
    common/canbus_gflags.h
    proto/canbus_conf.pb.cc
    proto/canbus_conf.pb.h
    proto/vehicle_parameter.pb.cc
    proto/vehicle_parameter.pb.h
)

target_link_libraries(canbus_component PUBLIC 
    cyberrt
    absl::strings
)

set_target_properties(canbus_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

add_executable(canbus_tester 
    tools/canbus_tester.cc
    common/canbus_gflags.cc
    common/canbus_gflags.h
)
target_link_libraries(canbus_tester PUBLIC 
    cyberrt
    common_msg
    common
    PkgConfig::SQLITE3_LIB
    absl::strings
)

add_executable(teleop 
    tools/teleop.cc
    common/canbus_gflags.cc
    common/canbus_gflags.h
)
target_link_libraries(teleop PUBLIC 
    cyberrt
    common_msg
    common
    absl::strings
    PkgConfig::SQLITE3_LIB
)