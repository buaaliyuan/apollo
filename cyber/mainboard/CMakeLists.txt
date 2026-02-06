# ============================================================================
# cyber/mainboard/CMakeLists.txt
# Mirrors: cyber/mainboard/BUILD
# ============================================================================

apollo_cc_binary(
    NAME mainboard
    SRCS
        mainboard.cc
        module_argument.cc
        module_argument.h
        module_controller.cc
        module_controller.h
    DEPS
        cyber
        cyber_plugin_manager
        dag_conf_cc_proto
    LINKOPTS
        -pthread
        /usr/lib/libprofiler.so
        /usr/lib/libtcmalloc.so
)
