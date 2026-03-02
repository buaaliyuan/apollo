# ============================================================================
# modules/perception/barrier_recognition/CMakeLists.txt
# Component: libbarrier_recognition_component.so
# ============================================================================

add_library(barrier_recognition_component SHARED)

target_sources(barrier_recognition_component
PRIVATE
	barrier_recognition_component.cc
	detector/barrier_recognition_bank.cc
	tracker/barrier_status_tracker.cc
	proto/barrier_recognition_component_config.pb.cc
	detector/proto/barrier_bank_config.pb.cc
	detector/proto/straight_pole_barrier_config.pb.cc
	tracker/proto/barrier_tracker_config.pb.cc
)

target_link_libraries(barrier_recognition_component
PUBLIC
	cyber
	msg_proto
	modules_common
	perception_common
	Eigen3::Eigen
	leveldb
)

install(TARGETS barrier_recognition_component
	ARCHIVE DESTINATION lib
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)