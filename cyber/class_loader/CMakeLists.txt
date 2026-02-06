# ============================================================================
# cyber/class_loader/CMakeLists.txt
# Mirrors: cyber/class_loader/BUILD
# ============================================================================

add_subdirectory(shared_library)
add_subdirectory(utility)

apollo_cc_library(
    NAME cyber_class_loader
    SRCS
        class_loader.cc
        class_loader_manager.cc
    HDRS
        class_loader.h
        class_loader_register_macro.h
        class_loader_manager.h
    DEPS
        shared_library
        class_loader_utility
        cyber_common
)
