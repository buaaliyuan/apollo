add_library(latency_statistic_component SHARED
    latency_statistic_component.cc
    latency_statistic_gflags.cc
)

target_link_libraries(latency_statistic_component
PRIVATE
    cyber
    modules_common
)