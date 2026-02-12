add_executable(listener listener.cc)
target_link_libraries(listener PRIVATE cyber)

add_executable(talker talker.cc)
target_link_libraries(talker PRIVATE cyber)

add_executable(paramserver paramserver.cc)
target_link_libraries(paramserver PRIVATE cyber)

add_executable(service service.cc)
target_link_libraries(service PRIVATE cyber)

add_executable(record record.cc)
target_link_libraries(record PRIVATE cyber)

add_subdirectory(proto)
add_subdirectory(common_component_example)
add_subdirectory(timer_component_example)


install(TARGETS listener talker paramserver service record
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)