file(GLOB_RECURSE TRANSFORM_SOURCES "*.cc")
list(FILTER TRANSFORM_SOURCES EXCLUDE REGEX ".*_test.cc$")
add_library(static_transform_component MODULE ${TRANSFORM_SOURCES})
target_compile_definitions(static_transform_component 
PRIVATE 
    MODULE_NAME="transform"
)

target_link_libraries(static_transform_component 
PRIVATE 
    cyber
    tf2
    yaml-cpp
    modules_common

)

install(TARGETS static_transform_component
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)

file(RELATIVE_PATH INSTALL_PATH "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
install(DIRECTORY conf dag launch DESTINATION ${INSTALL_PATH})