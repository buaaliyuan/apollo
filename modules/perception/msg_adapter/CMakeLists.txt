# ============================================================================
# modules/perception/msg_adapter/CMakeLists.txt
# Component: libmsg_adapter_component.so
# ============================================================================

add_library(msg_adapter_component SHARED)

target_sources(msg_adapter_component
PRIVATE
	msg_adapter_component.cc
	common/msg_adapter_gflags.cc
)

target_link_libraries(msg_adapter_component
PUBLIC
	cyber
	msg_proto
	modules_common
	perception_common
	Eigen3::Eigen
)

install(TARGETS msg_adapter_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
