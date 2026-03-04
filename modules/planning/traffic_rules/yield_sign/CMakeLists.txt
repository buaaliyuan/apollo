add_library(yield_sign SHARED
    yield_sign.cc
    proto/yield_sign.pb.cc
)

target_link_libraries(yield_sign PUBLIC
    cyber
    planning_base
)

install(TARGETS yield_sign
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
