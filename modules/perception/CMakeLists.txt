# ============================================================================
# modules/perception/CMakeLists.txt
# Top-level perception module — delegates to per-subdirectory CMakeLists.txt
#
# Each subdirectory has its own CMakeLists.txt referencing its BUILD file
# for deps, proto targets, component .so names, and install rules.
# ============================================================================

# GPU platform defines used by perception code (#if GPU_PLATFORM == NVIDIA/AMD)

add_compile_definitions(NVIDIA=0 AMD=1 GPU_PLATFORM=0 USE_GPU=1)  # NVIDIA by default

# ── 1. Common libraries (must come first — all sub-modules depend on these) ──
add_subdirectory(common)

# ── 2. Tools (some sub-modules like lane_detection depend on tools/offline) ──
# add_subdirectory(tools)

# ── 3. Pointcloud pipeline ──
add_subdirectory(pointcloud_preprocess)
add_subdirectory(pointcloud_map_based_roi)
add_subdirectory(pointcloud_ground_detection)
add_subdirectory(pointcloud_semantics)
add_subdirectory(pointcloud_motion)

# ── 4. Lidar pipeline ──
add_subdirectory(lidar_detection)
add_subdirectory(lidar_detection_filter)
add_subdirectory(lidar_segmentation)
add_subdirectory(lidar_tracking)
add_subdirectory(lidar_output)
add_subdirectory(lidar_cpdet_detection)

# ── 5. Camera pipeline ──
add_subdirectory(camera_detection_single_stage)
add_subdirectory(camera_detection_multi_stage)
add_subdirectory(camera_detection_bev)
add_subdirectory(camera_location_estimation)
add_subdirectory(camera_location_refinement)
add_subdirectory(camera_tracking)

# ── 6. Radar pipeline ──
add_subdirectory(radar_detection)
add_subdirectory(radar4d_detection)

# ── 7. Fusion ──
add_subdirectory(multi_sensor_fusion)

# ── 8. Lane detection ──
add_subdirectory(lane_detection)

# ── 9. Traffic light pipeline ──
add_subdirectory(traffic_light_region_proposal)
add_subdirectory(traffic_light_detection)
add_subdirectory(traffic_light_recognition)
add_subdirectory(traffic_light_tracking)

# ── 10. Motion service ──
add_subdirectory(motion_service)

# ── 11. Message adapter ──
add_subdirectory(msg_adapter)

# ── 12. Barrier recognition ──
add_subdirectory(barrier_recognition)

# ── 13. Perception plugins (must come after lidar_detection_filter, lidar_segmentation) ──
add_subdirectory(perception_plugin)
