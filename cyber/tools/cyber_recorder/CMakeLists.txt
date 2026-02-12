file(GLOB CPPS "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER CPPS EXCLUDE REGEX ".*_test.cc$")

add_executable(cyber_recorder ${CPPS})
target_link_libraries(cyber_recorder 
PRIVATE
    cyber
)

add_subdirectory(player)

install(TARGETS cyber_recorder
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)