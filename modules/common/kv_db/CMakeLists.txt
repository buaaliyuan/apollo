# modules/common/kv_db
apollo_cc_library(
    NAME kv_db
    SRCS kv_db.cc
    HDRS kv_db.h
    DEPS
        cyber
        common_util
        util_tool
        gflags
        absl
        sqlite3
)

apollo_cc_binary(
    NAME kv_db_tool
    SRCS kv_db_tool.cc
    DEPS kv_db cyber gflags absl sqlite3
)
