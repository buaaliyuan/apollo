add_executable(cyber_benchmark_reader cyber_benchmark_reader.cc)
target_link_libraries(cyber_benchmark_reader  cyber)

add_executable(cyber_benchmark_writer cyber_benchmark_writer.cc)
target_link_libraries(cyber_benchmark_writer  cyber)

install(TARGETS cyber_benchmark_reader cyber_benchmark_writer
    RUNTIME DESTINATION bin
)