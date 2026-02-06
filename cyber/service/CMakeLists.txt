# ============================================================================
# cyber/service/CMakeLists.txt
# Header-only library. Mirrors: cyber/service/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_service
    INTERFACE
    HDRS
        client.h
        service.h
        service_base.h
        client_base.h
    DEPS
        cyber_scheduler
)
