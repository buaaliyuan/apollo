# ============================================================================
# modules/audio/CMakeLists.txt
# ============================================================================

# Audio module requires libtorch (ATen) – skip if not available
find_library(TORCH_LIB torch PATHS /opt/apollo/sysroot/lib /usr/local/lib)
if(NOT TORCH_LIB)
    message(STATUS "Audio module SKIPPED (libtorch not found)")
    return()
endif()

# ── Proto ──
apollo_proto_library(
    NAME audio_conf_cc_proto
    SRCS proto/audio_conf.proto
)

# ── apollo_audio library ──
apollo_cc_library(
    NAME apollo_audio
    SRCS
        common/audio_gflags.cc
        common/audio_info.cc
        common/message_process.cc
        inference/direction_detection.cc
        inference/moving_detection.cc
        inference/siren_detection.cc
    HDRS
        common/audio_gflags.h
        common/audio_info.h
        common/message_process.h
        inference/direction_detection.h
        inference/moving_detection.h
        inference/siren_detection.h
    DEPS
        cyber
        common_math
        audio_cc_proto
        geometry_cc_proto
        microphone_audio_cc_proto
        gflags
        yaml-cpp
        eigen
        fftw3
    LINKOPTS -fopenmp
    COPTS -DMODULE_NAME="audio"
)

# ── audio_component ──
apollo_component(
    NAME libaudio_component.so
    SRCS audio_component.cc
    HDRS audio_component.h
    DEPS
        apollo_audio
        cyber
        audio_conf_cc_proto
        util_tool
        geometry_cc_proto
        localization_cc_proto
    COPTS -DMODULE_NAME="audio"
)
