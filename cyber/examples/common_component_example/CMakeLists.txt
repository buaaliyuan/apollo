add_library(common_component_example MODULE common_component_example.cc)
target_link_libraries(common_component_example  PRIVATE cyber)

install(TARGETS common_component_example
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

file(RELATIVE_PATH INSTALL_PATH "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
install(FILES common.dag DESTINATION ${INSTALL_PATH})
install(FILES common.launch DESTINATION ${INSTALL_PATH})