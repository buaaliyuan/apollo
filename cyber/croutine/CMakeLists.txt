# ============================================================================
# cyber/croutine/CMakeLists.txt
# Mirrors: cyber/croutine/BUILD
# ============================================================================

# Platform-specific assembly sources
if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64")
    set(SWAP_ASM detail/swap_x86_64.S)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
    set(SWAP_ASM detail/swap_aarch64.S)
else()
    message(FATAL_ERROR "Unsupported architecture: ${CMAKE_SYSTEM_PROCESSOR}. Only x86_64 and aarch64 are supported.")
endif()

apollo_cc_library(
    NAME cyber_croutine
    SRCS
        croutine.cc
        detail/routine_context.cc
        ${SWAP_ASM}
    HDRS
        croutine.h
        routine_factory.h
        detail/routine_context.h
    DEPS
        cyber_base
        cyber_common
        cyber_event
        cyber_time
    LINKOPTS -latomic
)

apollo_cc_test(NAME croutine_test SRCS croutine_test.cc DEPS cyber)
