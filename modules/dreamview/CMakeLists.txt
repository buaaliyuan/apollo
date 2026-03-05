add_executable(dreamview 
    main.cc
)

target_link_libraries(dreamview PUBLIC
    dreamview_backend
) 

add_library(dreamview_backend SHARED
    proto/camera_update.pb.cc
    proto/data_collection_table.pb.cc
    proto/dv_plugin_msg.pb.cc
    proto/plugin_config.pb.cc
    proto/point_cloud.pb.cc
    proto/preprocess_table.pb.cc
    proto/record.pb.cc
    proto/scenario.pb.cc
)

target_compile_definitions(dreamview PRIVATE
    WITH_TELEOP=0
)
add_subdirectory(backend)

install(TARGETS dreamview dreamview_backend
     RUNTIME DESTINATION bin
     LIBRARY DESTINATION lib
     ARCHIVE DESTINATION lib
) 