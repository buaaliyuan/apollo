
file(GLOB CPPS "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER CPPS EXCLUDE REGEX ".*_test.cc$")

add_executable(mainboard ${CPPS})
target_link_libraries(mainboard
PRIVATE
    cyber
)

install(TARGETS mainboard
    RUNTIME DESTINATION bin
)