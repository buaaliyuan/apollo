# ============================================================================
# modules/contrib/CMakeLists.txt
# Community contributed modules
# ============================================================================

# ── Cyber Bridge (WebSocket bridge for CyberRT) ──
apollo_cc_library(
    NAME contrib_cyber_bridge
    SRCS
        cyber_bridge/client.cc
        cyber_bridge/clients.cc
        cyber_bridge/node.cc
        cyber_bridge/server.cc
    DEPS
        cyber
        Boost::boost
    COPTS -DMODULE_NAME="cyber_bridge"
)

apollo_cc_binary(
    NAME cyber_bridge
    SRCS cyber_bridge/bridge.cc
    DEPS
        contrib_cyber_bridge
        Boost::boost
        gflags
)
