add_executable(tcp_echo_client tcp_echo_client.cc)
target_link_libraries(tcp_echo_client PRIVATE cyber)

add_executable(tcp_echo_server tcp_echo_server.cc)
target_link_libraries(tcp_echo_server PRIVATE cyber)

add_executable(udp_echo_client udp_echo_client.cc)
target_link_libraries(udp_echo_client PRIVATE cyber)

add_executable(udp_echo_server udp_echo_server.cc)
target_link_libraries(udp_echo_server PRIVATE cyber)

install(TARGETS tcp_echo_client tcp_echo_server udp_echo_client udp_echo_server
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)