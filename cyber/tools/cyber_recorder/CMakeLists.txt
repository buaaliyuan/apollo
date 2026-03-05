file(GLOB CPPS "${CMAKE_CURRENT_SOURCE_DIR}/player/*.cc")
list(FILTER CPPS EXCLUDE REGEX ".*_test.cc$")

add_library(cyber_recorder_module SHARED ${CPPS} info.cc recorder.cc recoverer.cc spliter.cc)
target_link_libraries(cyber_recorder_module 
PRIVATE
    cyber
)

add_executable(cyber_recorder main.cc)
target_link_libraries(cyber_recorder 
PRIVATE
    cyber_recorder_module
    cyber
)

add_subdirectory(player)

install(TARGETS cyber_recorder_module cyber_recorder
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)