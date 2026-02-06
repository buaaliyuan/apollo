# ============================================================================
# cyber/statistics/CMakeLists.txt
# Mirrors: cyber/statistics/BUILD
# ============================================================================

apollo_cc_library(
    NAME apollo_statistics
    SRCS statistics.cc
    HDRS statistics.h
    DEPS
        cyber_common
        role_attributes_cc_proto
        cyber_time
    LINKOPTS -lbvar
)
