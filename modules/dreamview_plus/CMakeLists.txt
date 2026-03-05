add_executable(dreamview_plus
    main.cc
    proto/data_handler.pb.cc
    proto/obstacle.pb.cc
)

target_link_libraries(dreamview_plus PUBLIC
    cyber
    msg_proto
    Eigen3::Eigen
    tf2
    pcl
    ${OpenCV_LIBS}
    modules_common
    sqlite3
    apollo_map
    Boost::thread
    yaml-cpp
    static_transform_component
    Boost::filesystem
    dreamview_backend
    cyber_recorder_module
)

add_subdirectory(backend)

install(TARGETS dreamview_plus
     RUNTIME DESTINATION bin
     LIBRARY DESTINATION lib
     ARCHIVE DESTINATION lib
)