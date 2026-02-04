set(PREDICTION_COMMON_LIBS
	cyberrt
	common_msg
	common
	gflags
)

file(GLOB_RECURSE PREDICTION_NETWORK_SRCS
	"network/*.cc"
	"network/*.h"
)
list(FILTER PREDICTION_NETWORK_SRCS EXCLUDE REGEX ".*_test.cc$")
add_library(apollo_prediction_network SHARED ${PREDICTION_NETWORK_SRCS})
target_link_libraries(apollo_prediction_network PUBLIC ${PREDICTION_COMMON_LIBS})
set_target_properties(apollo_prediction_network PROPERTIES POSITION_INDEPENDENT_CODE ON)

file(GLOB_RECURSE PREDICTION_CORE_SRCS
	"common/*.cc"
	"common/*.h"
	"container/*.cc"
	"container/*.h"
	"evaluator/*.cc"
	"evaluator/*.h"
	"pipeline/*.cc"
	"pipeline/*.h"
	"predictor/*.cc"
	"predictor/*.h"
	"scenario/*.cc"
	"scenario/*.h"
	"submodules/*.cc"
	"submodules/*.h"
    "proto/*.cc"
)
list(FILTER PREDICTION_CORE_SRCS EXCLUDE REGEX ".*_test.cc$|pipeline/vector_net_feature\\.cc$|pipeline/vector_net_offline_data\\.cc$|pipeline/records_to_offline_data\\.cc$")
add_library(apollo_prediction SHARED ${PREDICTION_CORE_SRCS})
target_compile_definitions(apollo_prediction PRIVATE MODULE_NAME=\"prediction\")
target_compile_options(apollo_prediction PRIVATE -fopenmp)
target_include_directories(apollo_prediction PUBLIC
    ${OpenCV_INCLUDE_DIRS}
)
target_link_libraries(apollo_prediction PUBLIC 
    ${PREDICTION_COMMON_LIBS} 
    apollo_prediction_network 
    gomp
    ${OpenCV_LIBS}
    CUDA::cudart
    CUDA::toolkit
    CUDA::nppig
    torch
    torch_cuda
    apollo_map
)
set_target_properties(apollo_prediction PROPERTIES POSITION_INDEPENDENT_CODE ON)

file(GLOB PREDICTION_COMPONENT_SRCS "prediction_component.cc" "prediction_component.h")
add_library(prediction_component SHARED ${PREDICTION_COMPONENT_SRCS})
target_compile_definitions(prediction_component PRIVATE MODULE_NAME=\"prediction\")
target_link_libraries(prediction_component PUBLIC apollo_prediction ${PREDICTION_COMMON_LIBS})
set_target_properties(prediction_component PROPERTIES POSITION_INDEPENDENT_CODE ON)

# Binary executables in prediction
add_executable(vector_net_feature pipeline/vector_net_feature.cc)
target_compile_definitions(vector_net_feature PRIVATE MODULE_NAME=\"prediction\")
target_link_libraries(vector_net_feature apollo_prediction ${PREDICTION_COMMON_LIBS})

add_executable(vector_net_offline_data pipeline/vector_net_offline_data.cc)
target_compile_definitions(vector_net_offline_data PRIVATE MODULE_NAME=\"prediction\")
target_link_libraries(vector_net_offline_data apollo_prediction ${PREDICTION_COMMON_LIBS})

add_executable(records_to_offline_data pipeline/records_to_offline_data.cc)
target_compile_definitions(records_to_offline_data PRIVATE MODULE_NAME=\"prediction\")
target_compile_options(records_to_offline_data PRIVATE -fopenmp)
target_link_libraries(records_to_offline_data apollo_prediction ${PREDICTION_COMMON_LIBS} gomp absl::strings Boost::filesystem Boost::program_options)
