add_library(common_component_example MODULE common_component_example.cc)
target_link_libraries(common_component_example  PRIVATE cyber)

install(TARGETS common_component_example
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)