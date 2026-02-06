# modules/common/math/qp_solver
apollo_cc_library(
    NAME qp_solver
    SRCS qp_solver.cc
    HDRS qp_solver.h
    DEPS eigen
)
