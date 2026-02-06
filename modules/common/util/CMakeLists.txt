# modules/common/util
apollo_cc_library(
    NAME message_util
    HDRS message_util.h
    DEPS cyber absl protobuf::libprotobuf
    INTERFACE
)

apollo_cc_library(
    NAME util_tool
    SRCS
        data_extraction.cc
        json_util.cc
        perf_util.cc
        string_util.cc
    HDRS
        color.h
        eigen_defs.h
        data_extraction.h
        factory.h
        future.h
        json_util.h
        lru_cache.h
        map_util.h
        perf_util.h
        string_util.h
        time_util.h
    DEPS
        cyber
        message_util
        Boost::boost
        Boost::filesystem
        eigen
        nlohmann_json::nlohmann_json
        absl
        protobuf::libprotobuf
)

apollo_cc_library(
    NAME util_lib
    SRCS util.cc
    HDRS util.h
    DEPS
        cyber
        config_gflags
        common_math
        geometry_cc_proto
        pnc_point_cc_proto
        gflags
)

apollo_cc_library(
    NAME common_util
    SRCS util.cc
    HDRS
        point_factory.h
        points_downsampler.h
        util.h
    DEPS
        cyber
        config_gflags
        common_math
        geometry_cc_proto
        pnc_point_cc_proto
        gflags
)
