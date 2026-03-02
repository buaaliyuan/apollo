add_library(apollo_map SHARED)
target_sources(apollo_map 
PRIVATE 
        "hdmap/adapter/opendrive_adapter.cc"
        "hdmap/adapter/proto_organizer.cc"
        "hdmap/adapter/xml_parser/coordinate_convert_tool.cc"
        "hdmap/adapter/xml_parser/header_xml_parser.cc"
        "hdmap/adapter/xml_parser/junctions_xml_parser.cc"
        "hdmap/adapter/xml_parser/lanes_xml_parser.cc"
        "hdmap/adapter/xml_parser/objects_xml_parser.cc"
        "hdmap/adapter/xml_parser/roads_xml_parser.cc"
        "hdmap/adapter/xml_parser/signals_xml_parser.cc"
        "hdmap/adapter/xml_parser/util_xml_parser.cc"
        "hdmap/hdmap.cc"
        "hdmap/hdmap_common.cc"
        "hdmap/hdmap_impl.cc"
        "hdmap/hdmap_util.cc"
        "pnc_map/path.cc"
        "pnc_map/pnc_map_base.cc"
        "pnc_map/route_segments.cc"
        "relative_map/common/relative_map_gflags.cc"
        "relative_map/navigation_lane.cc"
        "relative_map/relative_map.cc"
        "relative_map/proto/navigator_config.pb.cc"
        "relative_map/proto/relative_map_config.pb.cc"
)

target_link_libraries(apollo_map 
PUBLIC
    msg_proto
    cyber
    proj_lib
    gtest_headers
    Eigen3::Eigen
)

target_compile_definitions(apollo_map 
PRIVATE
    MODULE_NAME="map"
)

install(TARGETS apollo_map
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)