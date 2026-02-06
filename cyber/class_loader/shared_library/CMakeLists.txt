# ============================================================================
# cyber/class_loader/shared_library/CMakeLists.txt
# Mirrors: cyber/class_loader/shared_library/BUILD
# ============================================================================

apollo_cc_library(
    NAME shared_library
    SRCS shared_library.cc
    HDRS shared_library.h exceptions.h
    LINKOPTS -ldl
)
