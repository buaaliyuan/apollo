add_library(process_statistic_component SHARED
    process_statistic_component.cc
    process_statistic_gflags.cc
)

target_link_libraries(process_statistic_component
PRIVATE
    cyber
    modules_common
)