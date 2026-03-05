# ============================================================================
# Command Processor Base Library
# ============================================================================

# Utility library
add_library(lane_way_tool SHARED
    util/lane_way_tool.cc
    util/lane_way_tool.h
)

target_link_libraries(lane_way_tool PUBLIC
    cyber
    Eigen3::Eigen
)

add_library(message_reader SHARED
    util/message_reader.cc
    util/message_reader.h
)

target_link_libraries(message_reader PUBLIC
    cyber
)

add_library(message_writer SHARED
    util/message_writer.cc
    util/message_writer.h
)

target_link_libraries(message_writer PUBLIC
    cyber
)

# Base command processor library
add_library(command_processor_base STATIC
    command_processor_base.cc
    command_processor_base.h
    proto/command_processor_config.pb.cc
)

target_link_libraries(command_processor_base PUBLIC
    cyber
)

# Motion command processor base (header-only)
add_library(motion_command_processor_base INTERFACE)

target_link_libraries(motion_command_processor_base INTERFACE
    command_processor_base
    lane_way_tool
    message_reader
    message_writer
    cyber
    Eigen3::Eigen
    gtest_headers
)

target_compile_definitions(motion_command_processor_base INTERFACE
    MODULE_NAME="external_command"
)

# Install libraries
install(TARGETS command_processor_base lane_way_tool message_reader message_writer
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
