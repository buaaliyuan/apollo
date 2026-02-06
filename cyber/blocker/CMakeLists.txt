# ============================================================================
# cyber/blocker/CMakeLists.txt
# Mirrors: cyber/blocker/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_blocker
    SRCS
        blocker_manager.cc
    HDRS
        blocker_manager.h
        blocker.h
        intra_reader.h
        intra_writer.h
)

apollo_cc_test(NAME blocker_manager_test SRCS blocker_manager_test.cc DEPS cyber unit_test_cc_proto)
apollo_cc_test(NAME blocker_test         SRCS blocker_test.cc         DEPS cyber unit_test_cc_proto)
