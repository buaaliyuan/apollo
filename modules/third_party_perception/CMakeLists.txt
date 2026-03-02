add_library(third_party_perception_component SHARED)
target_sources(third_party_perception_component
PRIVATE
    common/third_party_perception_gflags.cc
    common/third_party_perception_util.cc
    integration_tests/third_party_perception_test_base.cc
    third_party_perception_base.cc
    third_party_perception_mobileye.cc
    third_party_perception_smartereye.cc
    tools/conversion_mobileye.cc
    tools/conversion_radar.cc
    tools/conversion_smartereye.cc
    tools/filter.cc
    tools/fusion.cc
)

target_link_libraries(third_party_perception_component
PUBLIC
    cyber
    msg_proto
    modules_common
)

install(TARGETS third_party_perception_component
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)