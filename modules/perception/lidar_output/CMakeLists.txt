add_library(lidar_output_component SHARED)
target_sources(lidar_output_component
PRIVATE
	lidar_output_component.cc
	proto/lidar_output_component_config.pb.cc
)
# target_compile_definitions(lidar_output_component
# PUBLIC
#     MODULE_NAME="lidar_output"
# )
target_link_libraries(lidar_output_component
PUBLIC
	cyber
	msg_proto
	modules_common
	perception_common
	leveldb
)
install(TARGETS lidar_output_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)

