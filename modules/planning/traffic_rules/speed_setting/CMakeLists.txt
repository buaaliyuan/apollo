add_library(speed_setting SHARED
    speed_setting.cc
)

target_link_libraries(speed_setting PUBLIC
    cyber
    planning_base
)

install(TARGETS speed_setting
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
