if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64")
    set(SWAP_ASM detail/swap_x86_64.S)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
    set(SWAP_ASM detail/swap_aarch64.S)
else()
    message(FATAL_ERROR "Unsupported architecture: ${CMAKE_SYSTEM_PROCESSOR}. Only x86_64 and aarch64 are supported.")
endif()


file(GLOB cyber_srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")
list(FILTER cyber_srcs EXCLUDE REGEX ".*_test.cc$")

target_sources(cyber
PRIVATE
    ${cyber_srcs}
    "detail/routine_context.cc"
    ${SWAP_ASM}
)