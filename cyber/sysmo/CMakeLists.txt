# ============================================================================
# cyber/sysmo/CMakeLists.txt
# Mirrors: cyber/sysmo/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_sysmo
    SRCS sysmo.cc
    HDRS sysmo.h
    DEPS cyber_scheduler
)

apollo_cc_test(NAME sysmo_test SRCS sysmo_test.cc DEPS cyber)
