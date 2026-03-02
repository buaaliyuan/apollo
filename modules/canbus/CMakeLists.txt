add_library(apollo_canbus   SHARED)
target_sources(apollo_canbus
PRIVATE
    common/canbus_gflags.cc
    vehicle/abstract_vehicle_factory.cc
    proto/canbus_conf.pb.cc
    proto/vehicle_parameter.pb.cc
    vehicle/abstract_vehicle_factory.cc
)
target_link_libraries(apollo_canbus
PUBLIC
    cyber
    msg_proto
    modules_common
)
target_compile_definitions(apollo_canbus
PUBLIC
    MODULE_NAME="canbus")

add_library(canbus_component SHARED)
target_sources(canbus_component
PRIVATE
    canbus_component.cc
)
target_link_libraries(canbus_component
PUBLIC
    apollo_canbus
)