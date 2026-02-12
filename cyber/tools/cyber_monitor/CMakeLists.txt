file(GLOB CPPS "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER CPPS EXCLUDE REGEX ".*_test.cc$")

add_executable(cyber_monitor ${CPPS})
target_link_libraries(cyber_monitor
PRIVATE
    cyber
    ${CURSES_LIBRARIES}
)

install(TARGETS cyber_monitor
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)