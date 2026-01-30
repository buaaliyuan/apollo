file(GLOB_RECURSE CCS "ch/*.cc" "ch/*.h")
list(FILTER CCS EXCLUDE REGEX ".*_test.cc$")
add_library(apollo_canbus_vehicle_ch SHARED ${CCS})
target_link_libraries(apollo_canbus_vehicle_ch PUBLIC
    cyberrt
    common
)

file(GLOB_RECURSE CCS "wey/*.cc" "wey/*.h")
list(FILTER CCS EXCLUDE REGEX ".*_test.cc$")
add_library(apollo_canbus_vehicle_wey SHARED ${CCS})
target_link_libraries(apollo_canbus_vehicle_wey PUBLIC
    cyberrt
    common
)

