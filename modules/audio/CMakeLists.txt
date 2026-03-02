add_library(audio_component SHARED)
target_sources(audio_component
PRIVATE
    common/audio_gflags.cc
    common/audio_info.cc
    common/message_process.cc
    inference/direction_detection.cc
    inference/moving_detection.cc
    inference/siren_detection.cc
    proto/audio_conf.pb.cc
)
target_include_directories(audio_component
PUBLIC
    ${TORCH_INCLUDE_DIRS}
)
target_link_libraries(audio_component
PUBLIC
    cyber
    msg_proto
    modules_common
    ${TORCH_LIBRARIES}
)

target_compile_options(audio_component
PUBLIC
    -fopenmp)

install(TARGETS audio_component
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)