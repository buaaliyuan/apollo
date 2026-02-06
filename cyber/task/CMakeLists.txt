# ============================================================================
# cyber/task/CMakeLists.txt
# Mirrors: cyber/task/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_task
    SRCS task_manager.cc
    HDRS task.h task_manager.h
    DEPS cyber_scheduler
    COPTS -faligned-new
)

apollo_cc_test(NAME task_test SRCS task_test.cc DEPS cyber)
