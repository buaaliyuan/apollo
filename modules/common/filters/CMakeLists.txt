# modules/common/filters
apollo_cc_library(
    NAME filters
    SRCS
        digital_filter.cc
        digital_filter_coefficients.cc
        mean_filter.cc
    HDRS
        digital_filter.h
        digital_filter_coefficients.h
        mean_filter.h
    DEPS cyber
)
