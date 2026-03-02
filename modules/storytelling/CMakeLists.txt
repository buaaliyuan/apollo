add_library(storytelling_component SHARED)
target_sources(storytelling_component
PRIVATE
    storytelling.cc
    common/storytelling_gflags.cc
    story_tellers/close_to_junction_teller.cc
    proto/storytelling_config.pb.cc
)

target_compile_definitions(storytelling_component
PUBLIC
    MODULE_NAME="storytelling"
)

target_link_libraries(storytelling_component
PUBLIC
    cyber
    msg_proto
    modules_common
)

install(TARGETS storytelling_component
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)