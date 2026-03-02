add_library(lidar_detection_filter_component SHARED)
target_sources(lidar_detection_filter_component
PRIVATE
	lidar_detection_filter_component.cc
	object_filter_bank/object_filter_bank.cc
	object_filter_bank/background_filter/background_filter.cc
	object_filter_bank/roi_boundary_filter/roi_boundary_filter.cc
	object_filter_bank/strategy_filter/strategy_filter.cc
	object_filter_bank/proto/background_filter_config.pb.cc
	object_filter_bank/proto/filter_bank_config.pb.cc
	object_filter_bank/proto/roi_boundary_filter_config.pb.cc
	object_filter_bank/proto/strategy_filter_config.pb.cc
	proto/lidar_detection_filter_component_config.pb.cc
)
target_include_directories(lidar_detection_filter_component
PUBLIC
	${CUDA_INCLUDE_DIRS}
)
# target_compile_definitions(lidar_detection_filter_component
# PUBLIC
#     MODULE_NAME="lidar_detection_filter"
# )
target_link_libraries(lidar_detection_filter_component
PUBLIC
	cyber
	msg_proto
	modules_common
)
install(TARGETS lidar_detection_filter_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
