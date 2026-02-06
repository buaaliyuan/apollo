# ============================================================================
# cyber/common/CMakeLists.txt
# Mirrors: cyber/common/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_common
    SRCS
        file.cc
        global_data.cc
    HDRS
        environment.h
        file.h
        global_data.h
        log.h
        macros.h
        time_conversion.h
        types.h
        util.h
    DEPS
        cyber_binary
        cyber_base
        cyber_conf_cc_proto
        transport_conf_cc_proto
        glog::glog
        nlohmann_json::nlohmann_json
        protobuf::libprotobuf
)

# Tests
apollo_cc_test(NAME file_test        SRCS file_test.cc        DEPS cyber unit_test_cc_proto)
apollo_cc_test(NAME log_test         SRCS log_test.cc         DEPS cyber)
apollo_cc_test(NAME environment_test SRCS environment_test.cc DEPS cyber_common)
apollo_cc_test(NAME macros_test      SRCS macros_test.cc      DEPS cyber)
