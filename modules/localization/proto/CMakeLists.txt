file(GLOB_RECURSE LOCALIZATION_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
add_library(localization_proto SHARED ${LOCALIZATION_SOURCES})
target_link_libraries(localization_proto
PUBLIC
    cyber
)