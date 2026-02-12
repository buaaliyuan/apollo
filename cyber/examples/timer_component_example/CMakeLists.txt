add_library(timer_component_example MODULE timer_component_example.cc)
target_link_libraries(timer_component_example PRIVATE cyber)

install(TARGETS timer_component_example
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)