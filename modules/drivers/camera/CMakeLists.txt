file(GLOB_RECURSE CCS "*.cc" "*.cu")
list(FILTER CCS EXCLUDE REGEX ".*_test.cc$")
add_library(camera_component MODULE ${CCS})
target_link_libraries(camera_component 
PRIVATE 
    cyber
    ${OpenCV_LIBS}
    ffmpeg
    adv_plat
    msg_proto

)

target_compile_options(camera_component PRIVATE -fopenmp -mavx2 -mavx)
install(TARGETS camera_component
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

file(RELATIVE_PATH INSTALL_PATH "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
install(DIRECTORY conf dag launch DESTINATION ${INSTALL_PATH})