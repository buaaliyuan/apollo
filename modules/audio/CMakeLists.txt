file(GLOB_RECURSE SRCS "*.cc" "*.h")
list(FILTER SRCS EXCLUDE REGEX ".*_test.cc$|.*processing\\.cc$")

add_library(audio_component SHARED 
    ${SRCS}

)

target_include_directories(audio_component 
PUBLIC 
    /usr/local/libtorch_gpu/include
    /usr/local/libtorch_gpu/include/torch/csrc/api/include/
)
target_link_directories(audio_component
PUBLIC
    /usr/local/libtorch_gpu/lib
)
target_link_libraries(audio_component PUBLIC
    cyberrt
    common_msg
    Eigen3::Eigen
    torch
    torch_cuda
    yaml-cpp
)
set_target_properties(audio_component PROPERTIES POSITION_INDEPENDENT_CODE ON)


add_executable(audio_offline_processing
    tools/audio_offline_processing.cc
    #这两个配置跨模块依赖proto
    ${PROJECT_SOURCE_DIR}/modules/drivers/microphone/proto/audio.pb.cc
    ${PROJECT_SOURCE_DIR}/modules/drivers/microphone/proto/audio.pb.h
    ${PROJECT_SOURCE_DIR}/modules/drivers/microphone/proto/microphone_config.pb.cc
    ${PROJECT_SOURCE_DIR}/modules/drivers/microphone/proto/microphone_config.pb.h
)
target_link_libraries(audio_offline_processing PUBLIC
    audio_component
    common_msg
    common
    sqlite3
)