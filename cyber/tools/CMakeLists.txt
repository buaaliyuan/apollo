add_subdirectory(cyber_monitor)
add_subdirectory(cyber_recorder)

install(PROGRAMS
    cyber_channel/cyber_channel.py
    DESTINATION bin
    RENAME cyber_channel
)

install(PROGRAMS
    cyber_launch/cyber_launch.py
    DESTINATION bin
    RENAME cyber_launch
)

install(PROGRAMS
    cyber_node/cyber_node.py
    DESTINATION bin
    RENAME cyber_node
)

install(PROGRAMS
    cyber_performance/cyber_performance.py
    DESTINATION bin
    RENAME cyber_performance
)

install(PROGRAMS
    cyber_service/cyber_service.py
    DESTINATION bin
    RENAME cyber_service
)