# ============================================================================
# cyber/logger/CMakeLists.txt
# Mirrors: cyber/logger/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_logger
    SRCS
        async_logger.cc
        log_file_object.cc
        logger_util.cc
        logger.cc
    HDRS
        async_logger.h
        log_file_object.h
        logger.h
        logger_util.h
    DEPS
        cyber_binary
        cyber_common
        cyber_base
)

apollo_cc_test(NAME logger_test          SRCS logger_test.cc          DEPS cyber)
apollo_cc_test(NAME async_logger_test    SRCS async_logger_test.cc    DEPS cyber)
apollo_cc_test(NAME log_file_object_test SRCS log_file_object_test.cc DEPS cyber)
apollo_cc_test(NAME logger_util_test     SRCS logger_util_test.cc     DEPS cyber)
