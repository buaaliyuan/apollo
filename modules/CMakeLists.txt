# ============================================================================
# modules/CMakeLists.txt
# Top-level build for Apollo modules
# ============================================================================

# ── Proto message libraries (must be defined first) ──
add_subdirectory(common_msgs)
add_subdirectory(safety_manager_msgs)
add_subdirectory(statistics_msgs)

# ── Common utility libraries ──
add_subdirectory(common)

# ── Level-1: Core infrastructure (no inter-module deps) ──
add_subdirectory(transform)
add_subdirectory(drivers)          # drivers/canbus base library

# ── Level-2: Depends on transform/drivers ──
add_subdirectory(map)
add_subdirectory(routing)

# ── Level-3: Simpler application modules ──
add_subdirectory(guardian)
add_subdirectory(bridge)
add_subdirectory(storytelling)
add_subdirectory(canbus)
add_subdirectory(audio)
add_subdirectory(third_party_perception)

# ── Level-4: Heavy algorithm modules ──
add_subdirectory(perception)
add_subdirectory(localization)
add_subdirectory(prediction)
add_subdirectory(control)
add_subdirectory(planning)

# ── Level-5: Modules with cross-deps ──
add_subdirectory(external_command)
add_subdirectory(v2x)

# ── Level-6: Dreamview (depends on many modules) ──
add_subdirectory(dreamview)
add_subdirectory(dreamview_plus)

# ── Level-7: Monitor & Task Manager (depend on dreamview) ──
add_subdirectory(monitor)
add_subdirectory(task_manager)
