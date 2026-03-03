add_library(rtk_localization_component SHARED
  rtk_localization_component.cc
  rtk_localization.cc
)

target_link_libraries(rtk_localization_component PUBLIC
    cyber
    localization_common_object
    Eigen3::Eigen
    gtest_headers
    tf2
    localization_proto
)

install(TARGETS rtk_localization_component
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)