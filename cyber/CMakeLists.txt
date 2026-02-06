# ============================================================================
# cyber/CMakeLists.txt
# Main CyberRT build file. Mirrors: cyber/BUILD
#
# Builds all CyberRT sub-modules and assembles them into a single
# shared library: libcyber.so (equivalent to the Bazel "cyber" target).
# ============================================================================

# ── Proto generation (must come first) ────────────────────────────
add_subdirectory(proto)

# ── Sub-modules (order follows dependency graph) ──────────────────
add_subdirectory(base)
add_subdirectory(context)
add_subdirectory(common)
add_subdirectory(event)
add_subdirectory(time)
add_subdirectory(croutine)
add_subdirectory(data)
add_subdirectory(scheduler)
add_subdirectory(task)
add_subdirectory(timer)
add_subdirectory(logger)
add_subdirectory(message)
add_subdirectory(blocker)
add_subdirectory(class_loader)
add_subdirectory(statistics)
add_subdirectory(service)
add_subdirectory(transport)
add_subdirectory(service_discovery)
add_subdirectory(node)
add_subdirectory(io)
add_subdirectory(record)
add_subdirectory(parameter)
add_subdirectory(plugin_manager)
add_subdirectory(profiler)
add_subdirectory(sysmo)
add_subdirectory(component)
add_subdirectory(mainboard)

# ── Top-level cyber_binary and cyber_state libraries ──────────────
# Mirrors: cyber_binary target in cyber/BUILD
apollo_cc_library(
    NAME cyber_binary
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/binary.cc
    HDRS ${CMAKE_CURRENT_SOURCE_DIR}/binary.h
)

# Mirrors: cyber_state target in cyber/BUILD
apollo_cc_library(
    NAME cyber_state
    SRCS ${CMAKE_CURRENT_SOURCE_DIR}/state.cc
    HDRS ${CMAKE_CURRENT_SOURCE_DIR}/state.h
    DEPS cyber_common
)

# ── Aggregate shared library: libcyber.so ─────────────────────────
# This is the main deliverable, equivalent to the Bazel "cyber" target.
# It combines all OBJECT libraries into a single shared library.
add_library(cyber SHARED
    ${CMAKE_CURRENT_SOURCE_DIR}/cyber.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/init.cc
    $<TARGET_OBJECTS:cyber_binary>
    $<TARGET_OBJECTS:cyber_state>
    $<TARGET_OBJECTS:cyber_common>
    $<TARGET_OBJECTS:cyber_event>
    $<TARGET_OBJECTS:cyber_time>
    $<TARGET_OBJECTS:cyber_croutine>
    $<TARGET_OBJECTS:cyber_scheduler>
    $<TARGET_OBJECTS:cyber_task>
    $<TARGET_OBJECTS:cyber_timer>
    $<TARGET_OBJECTS:cyber_logger>
    $<TARGET_OBJECTS:cyber_message>
    $<TARGET_OBJECTS:cyber_blocker>
    $<TARGET_OBJECTS:shared_library>
    $<TARGET_OBJECTS:class_loader_utility>
    $<TARGET_OBJECTS:cyber_class_loader>
    $<TARGET_OBJECTS:apollo_statistics>
    $<TARGET_OBJECTS:cyber_service_discovery_role>
    $<TARGET_OBJECTS:cyber_transport>
    $<TARGET_OBJECTS:cyber_service_discovery>
    $<TARGET_OBJECTS:cyber_node>
    $<TARGET_OBJECTS:cyber_io>
    $<TARGET_OBJECTS:cyber_record>
    $<TARGET_OBJECTS:cyber_parameter>
    $<TARGET_OBJECTS:cyber_plugin_manager>
    $<TARGET_OBJECTS:cyber_profiler>
    $<TARGET_OBJECTS:cyber_sysmo>
    $<TARGET_OBJECTS:cyber_component>
    # Proto objects
    $<TARGET_OBJECTS:clock_cc_proto>
    $<TARGET_OBJECTS:perf_conf_cc_proto>
    $<TARGET_OBJECTS:proto_desc_cc_proto>
    $<TARGET_OBJECTS:record_cc_proto>
    $<TARGET_OBJECTS:run_mode_conf_cc_proto>
    $<TARGET_OBJECTS:transport_conf_cc_proto>
    $<TARGET_OBJECTS:qos_profile_cc_proto>
    $<TARGET_OBJECTS:choreography_conf_cc_proto>
    $<TARGET_OBJECTS:classic_conf_cc_proto>
    $<TARGET_OBJECTS:parameter_cc_proto>
    $<TARGET_OBJECTS:unit_test_cc_proto>
    $<TARGET_OBJECTS:simple_cc_proto>
    $<TARGET_OBJECTS:component_conf_cc_proto>
    $<TARGET_OBJECTS:role_attributes_cc_proto>
    $<TARGET_OBJECTS:topology_change_cc_proto>
    $<TARGET_OBJECTS:scheduler_conf_cc_proto>
    $<TARGET_OBJECTS:dag_conf_cc_proto>
    $<TARGET_OBJECTS:cyber_conf_cc_proto>
)

target_include_directories(cyber PUBLIC
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_BINARY_DIR}
)

target_link_libraries(cyber PUBLIC
    # Third-party libraries
    protobuf::libprotobuf
    glog::glog
    gflags
    fastrtps
    uuid
    tinyxml2::tinyxml2
    nlohmann_json::nlohmann_json
    # System libraries
    -lrt
    -ldl
    -latomic
    -lpthread
    -lbvar
)

set_target_properties(cyber PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
    OUTPUT_NAME "cyber"
)

# Install rules
install(TARGETS cyber
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/
    DESTINATION include/cyber
    FILES_MATCHING
        PATTERN "*.h"
        PATTERN "build" EXCLUDE
        PATTERN "docs" EXCLUDE
        PATTERN "doxy-docs" EXCLUDE
        PATTERN "examples" EXCLUDE
        PATTERN "benchmark" EXCLUDE
        PATTERN "*_test.cc" EXCLUDE
)

# Install generated proto headers
install(DIRECTORY ${CMAKE_BINARY_DIR}/cyber/proto/
    DESTINATION include/cyber/proto
    FILES_MATCHING PATTERN "*.pb.h"
)

# Install conf files
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/conf/
    DESTINATION share/cyber/conf
    FILES_MATCHING PATTERN "*.conf"
)

# ============================================================================
# cyber/tools — C++ binary tools
# ============================================================================

# ── cyber_recorder library (reusable by dreamview_plus etc.) ──────
apollo_cc_library(
    NAME cyber_recorder_lib
    SRCS
        tools/cyber_recorder/recorder.cc
        tools/cyber_recorder/info.cc
        tools/cyber_recorder/recoverer.cc
        tools/cyber_recorder/spliter.cc
        tools/cyber_recorder/player/player.cc
        tools/cyber_recorder/player/play_task.cc
        tools/cyber_recorder/player/play_task_buffer.cc
        tools/cyber_recorder/player/play_task_consumer.cc
        tools/cyber_recorder/player/play_task_producer.cc
    HDRS
        tools/cyber_recorder/recorder.h
        tools/cyber_recorder/info.h
        tools/cyber_recorder/recoverer.h
        tools/cyber_recorder/spliter.h
        tools/cyber_recorder/player/player.h
        tools/cyber_recorder/player/play_task.h
        tools/cyber_recorder/player/play_task_buffer.h
        tools/cyber_recorder/player/play_task_consumer.h
        tools/cyber_recorder/player/play_task_producer.h
        tools/cyber_recorder/player/play_param.h
    DEPS
        cyber
        record_cc_proto
        fastrtps
)

# ── cyber_recorder binary ────────────────────────────────────────
apollo_cc_binary(
    NAME cyber_recorder
    SRCS tools/cyber_recorder/main.cc
    DEPS cyber_recorder_lib cyber record_cc_proto
    LINKOPTS -lpthread -lprofiler -ltcmalloc
)

# ── cyber_monitor binary ─────────────────────────────────────────
apollo_cc_binary(
    NAME cyber_monitor
    SRCS
        tools/cyber_monitor/main.cc
        tools/cyber_monitor/cyber_topology_message.cc
        tools/cyber_monitor/general_channel_message.cc
        tools/cyber_monitor/general_message.cc
        tools/cyber_monitor/general_message_base.cc
        tools/cyber_monitor/renderable_message.cc
        tools/cyber_monitor/screen.cc
    DEPS cyber
    LINKOPTS -lncurses
)

# ============================================================================
# cyber/examples — Example binaries and components
# ============================================================================

# ── examples proto ────────────────────────────────────────────────
apollo_proto_library(
    NAME examples_cc_proto
    SRCS examples/proto/examples.proto
)

# ── Example binaries ─────────────────────────────────────────────
apollo_cc_binary(
    NAME cyber_example_talker
    SRCS examples/talker.cc
    DEPS cyber examples_cc_proto
)

apollo_cc_binary(
    NAME cyber_example_listener
    SRCS examples/listener.cc
    DEPS cyber examples_cc_proto
)

apollo_cc_binary(
    NAME cyber_example_paramserver
    SRCS examples/paramserver.cc
    DEPS cyber
)

apollo_cc_binary(
    NAME cyber_example_service
    SRCS examples/service.cc
    DEPS cyber examples_cc_proto
)

apollo_cc_binary(
    NAME cyber_example_record
    SRCS examples/record.cc
    DEPS cyber examples_cc_proto
)

# ── Example components (shared libraries) ─────────────────────────
apollo_component(
    NAME libcommon_component_example.so
    SRCS examples/common_component_example/common_component_example.cc
    HDRS examples/common_component_example/common_component_example.h
    DEPS cyber examples_cc_proto
)

apollo_component(
    NAME libtimer_component_example.so
    SRCS examples/timer_component_example/timer_component_example.cc
    HDRS examples/timer_component_example/timer_component_example.h
    DEPS cyber examples_cc_proto
)

# ── Example channel writers ───────────────────────────────────────
apollo_cc_binary(
    NAME channel_test_writer
    SRCS examples/common_component_example/channel_test_writer.cc
    DEPS cyber examples_cc_proto
)

apollo_cc_binary(
    NAME channel_prediction_writer
    SRCS examples/common_component_example/channel_prediction_writer.cc
    DEPS cyber examples_cc_proto
)
