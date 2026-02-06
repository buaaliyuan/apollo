# ============================================================================
# modules/common/CMakeLists.txt
# Shared utility libraries used across Apollo modules
# ============================================================================

# Proto definitions local to common/
add_subdirectory(adapters/proto)
add_subdirectory(latency_recorder/proto)
add_subdirectory(vehicle_model/proto)
add_subdirectory(vehicle_state/proto)
add_subdirectory(util/testdata)

# Libraries (ordered by dependency)
add_subdirectory(adapters)
add_subdirectory(configs)
add_subdirectory(util)
add_subdirectory(filters)
add_subdirectory(math)
add_subdirectory(status)
add_subdirectory(service_wrapper)
add_subdirectory(monitor_log)
add_subdirectory(kv_db)
add_subdirectory(latency_recorder)
add_subdirectory(vehicle_model)
add_subdirectory(vehicle_state)
