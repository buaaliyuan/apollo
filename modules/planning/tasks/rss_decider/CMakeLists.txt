add_library(rss_decider SHARED
    rss_decider.cc
    proto/rss_decider.pb.cc
)

target_link_libraries(rss_decider PUBLIC
    cyber
    planning_base
    ad_rss
)

install(TARGETS rss_decider
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
