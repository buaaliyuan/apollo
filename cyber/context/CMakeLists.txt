# ============================================================================
# cyber/context/CMakeLists.txt
# Header-only library. Mirrors: cyber/context/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_context
    INTERFACE
    HDRS context.h
)

apollo_cc_test(NAME cyber_context_test SRCS context_test.cc DEPS cyber_context LINKOPTS -lm)
