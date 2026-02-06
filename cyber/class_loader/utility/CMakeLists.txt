# ============================================================================
# cyber/class_loader/utility/CMakeLists.txt
# Mirrors: cyber/class_loader/utility/BUILD
# ============================================================================

apollo_cc_library(
    NAME class_loader_utility
    SRCS class_loader_utility.cc class_factory.cc
    HDRS class_loader_utility.h class_factory.h
    DEPS
        shared_library
        cyber_common
)
