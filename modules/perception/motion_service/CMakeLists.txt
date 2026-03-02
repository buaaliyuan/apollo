# ============================================================================
# modules/perception/motion_service/CMakeLists.txt
# Component: libmotion_service_component.so
# ============================================================================

add_library(motion_service_component SHARED)

target_sources(motion_service_component
PRIVATE
	motion_service_component.cc
	motion/plane_motion.cc
	proto/motion_service_component.pb.cc
)

target_link_libraries(motion_service_component
PUBLIC
	cyber
	msg_proto
	modules_common
	perception_common
	Eigen3::Eigen
)

install(TARGETS motion_service_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)