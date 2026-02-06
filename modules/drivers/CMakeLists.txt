# ============================================================================
# modules/drivers/CMakeLists.txt
# ============================================================================

add_subdirectory(canbus)

# ── Driver protos needed by other modules ──
# microphone/proto/microphone_config.proto (no deps, define first)
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/microphone/proto/microphone_config.proto")
    apollo_proto_library(
        NAME microphone_config_cc_proto
        SRCS microphone/proto/microphone_config.proto
    )
endif()

# microphone/proto/audio.proto (needed by audio module)
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/microphone/proto/audio.proto")
    apollo_proto_library(
        NAME microphone_audio_cc_proto
        SRCS microphone/proto/audio.proto
        DEPS header_cc_proto microphone_config_cc_proto
    )
endif()
