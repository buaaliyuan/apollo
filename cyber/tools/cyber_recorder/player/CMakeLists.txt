file(GLOB CPPS "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER CPPS EXCLUDE REGEX ".*_test.cc$")

target_sources(cyber_recorder_module PRIVATE ${CPPS})
target_link_libraries(cyber_recorder_module PRIVATE cyber)