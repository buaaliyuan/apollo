# ============================================================================
# cyber/io/CMakeLists.txt
# Mirrors: cyber/io/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_io
    SRCS poll_handler.cc poller.cc session.cc
    HDRS
        poll_data.h
        poll_handler.h
        poller.h
        session.h
    DEPS
        cyber_common
        cyber_croutine
        cyber_base
        cyber_scheduler
        cyber_time
)

apollo_cc_test(NAME poller_test SRCS poller_test.cc DEPS cyber)

# Example binaries
apollo_cc_binary(NAME tcp_echo_client SRCS example/tcp_echo_client.cc DEPS cyber)
apollo_cc_binary(NAME tcp_echo_server SRCS example/tcp_echo_server.cc DEPS cyber)
apollo_cc_binary(NAME udp_echo_client SRCS example/udp_echo_client.cc DEPS cyber)
apollo_cc_binary(NAME udp_echo_server SRCS example/udp_echo_server.cc DEPS cyber)
