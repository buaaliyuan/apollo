add_library(resource_statistic_component SHARED
    cpu_resource_statistic.cc
    gpu_resource_statistic.cc
    memory_resource_statistic.cc
    resource_statistic_gflags.cc
    disk_resource_statistic.cc
    resource_statistic_gflags.cc
    util.cc
)

target_link_libraries(resource_statistic_component
PRIVATE
    cyber
    modules_common
)

target_include_directories(resource_statistic_component
PUBLIC
    ${CUDA_INCLUDE_DIRS}
)