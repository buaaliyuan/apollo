# ============================================================================
# cyber/parameter/CMakeLists.txt
# Mirrors: cyber/parameter/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_parameter
    SRCS
        parameter.cc
        parameter_client.cc
        parameter_server.cc
    HDRS
        parameter.h
        parameter_client.h
        parameter_server.h
        parameter_service_names.h
    DEPS
        cyber_message
        parameter_cc_proto
        cyber_node
        cyber_service
        fastrtps
)

apollo_cc_test(NAME parameter_test        SRCS parameter_test.cc        DEPS cyber)
apollo_cc_test(NAME parameter_client_test SRCS parameter_client_test.cc DEPS cyber)
apollo_cc_test(NAME parameter_server_test SRCS parameter_server_test.cc DEPS cyber)
