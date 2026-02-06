# ============================================================================
# cyber/plugin_manager/CMakeLists.txt
# Mirrors: cyber/plugin_manager/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_plugin_manager
    SRCS
        plugin_description.cc
        plugin_manager.cc
    HDRS
        plugin_description.h
        plugin_manager.h
    DEPS
        cyber_class_loader
        cyber_common
        tinyxml2::tinyxml2
)
