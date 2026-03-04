add_library(rule_based_stop_decider SHARED
    rule_based_stop_decider.cc
    proto/rule_based_stop_decider.pb.cc
)

target_link_libraries(rule_based_stop_decider PUBLIC
    cyber
    planning_base
)

install(TARGETS rule_based_stop_decider
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
