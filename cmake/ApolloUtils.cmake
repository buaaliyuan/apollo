# ============================================================================
# ApolloUtils.cmake
# Utility functions mirroring Bazel apollo_cc_library / apollo_cc_binary / apollo_cc_test
# ============================================================================

# ──────────────────────────────────────────────
# apollo_cc_library(
#     NAME <target_name>
#     SRCS <source_files...>
#     HDRS <header_files...>
#     DEPS <dep_targets...>
#     COPTS <compile_options...>
#     LINKOPTS <link_options...>
#     INTERFACE   # header-only library flag
# )
# ──────────────────────────────────────────────
function(apollo_cc_library)
    cmake_parse_arguments(ARG
        "INTERFACE"
        "NAME"
        "SRCS;HDRS;DEPS;COPTS;LINKOPTS"
        ${ARGN}
    )

    if(NOT ARG_NAME)
        message(FATAL_ERROR "apollo_cc_library: NAME is required")
    endif()

    if(ARG_INTERFACE OR (NOT ARG_SRCS))
        # Header-only (interface) library
        add_library(${ARG_NAME} INTERFACE)
        if(ARG_HDRS)
            target_sources(${ARG_NAME} INTERFACE ${ARG_HDRS})
        endif()
        if(ARG_DEPS)
            target_link_libraries(${ARG_NAME} INTERFACE ${ARG_DEPS})
        endif()
        if(ARG_COPTS)
            target_compile_options(${ARG_NAME} INTERFACE ${ARG_COPTS})
        endif()
        if(ARG_LINKOPTS)
            target_link_options(${ARG_NAME} INTERFACE ${ARG_LINKOPTS})
        endif()
    else()
        # Normal static library
        add_library(${ARG_NAME} STATIC ${ARG_SRCS} ${ARG_HDRS})
        if(ARG_DEPS)
            target_link_libraries(${ARG_NAME} PUBLIC ${ARG_DEPS})
        endif()
        if(ARG_COPTS)
            target_compile_options(${ARG_NAME} PRIVATE ${ARG_COPTS})
        endif()
        if(ARG_LINKOPTS)
            target_link_options(${ARG_NAME} PUBLIC ${ARG_LINKOPTS})
        endif()
    endif()
endfunction()

# ──────────────────────────────────────────────
# apollo_cc_binary(
#     NAME <target_name>
#     SRCS <source_files...>
#     DEPS <dep_targets...>
#     COPTS <compile_options...>
#     LINKOPTS <link_options...>
# )
# ──────────────────────────────────────────────
function(apollo_cc_binary)
    cmake_parse_arguments(ARG
        ""
        "NAME"
        "SRCS;DEPS;COPTS;LINKOPTS"
        ${ARGN}
    )

    if(NOT ARG_NAME)
        message(FATAL_ERROR "apollo_cc_binary: NAME is required")
    endif()

    add_executable(${ARG_NAME} ${ARG_SRCS})
    if(ARG_DEPS)
        target_link_libraries(${ARG_NAME} PRIVATE
            -Wl,--start-group ${ARG_DEPS} -Wl,--end-group)
    endif()
    if(ARG_COPTS)
        target_compile_options(${ARG_NAME} PRIVATE ${ARG_COPTS})
    endif()
    if(ARG_LINKOPTS)
        # Use target_link_libraries so that .so/.a paths and -l flags appear
        # AFTER object files on the linker command line (left-to-right rule).
        target_link_libraries(${ARG_NAME} PRIVATE ${ARG_LINKOPTS})
    endif()
endfunction()

# ──────────────────────────────────────────────
# apollo_cc_test(
#     NAME <target_name>
#     SRCS <source_files...>
#     DEPS <dep_targets...>
#     COPTS <compile_options...>
#     LINKOPTS <link_options...>
# )
# ──────────────────────────────────────────────
function(apollo_cc_test)
    if(NOT APOLLO_BUILD_TESTS)
        return()
    endif()

    cmake_parse_arguments(ARG
        ""
        "NAME"
        "SRCS;DEPS;COPTS;LINKOPTS"
        ${ARGN}
    )

    if(NOT ARG_NAME)
        message(FATAL_ERROR "apollo_cc_test: NAME is required")
    endif()

    add_executable(${ARG_NAME} ${ARG_SRCS})
    if(ARG_DEPS)
        target_link_libraries(${ARG_NAME} PRIVATE
            -Wl,--start-group ${ARG_DEPS} -Wl,--end-group)
    endif()
    target_link_libraries(${ARG_NAME} PRIVATE GTest::gtest GTest::gtest_main)
    if(ARG_COPTS)
        target_compile_options(${ARG_NAME} PRIVATE ${ARG_COPTS})
    endif()
    if(ARG_LINKOPTS)
        target_link_options(${ARG_NAME} PRIVATE ${ARG_LINKOPTS})
    endif()

    include(GoogleTest)
    gtest_discover_tests(${ARG_NAME})
endfunction()

# ──────────────────────────────────────────────
# apollo_component(
#     NAME <target_name>           e.g. "libguardian_component.so"
#     SRCS <source_files...>
#     HDRS <header_files...>
#     DEPS <dep_targets...>
#     COPTS <compile_options...>
# )
# Builds a shared library (.so) that acts as a CyberRT plugin component.
# ──────────────────────────────────────────────
function(apollo_component)
    cmake_parse_arguments(ARG
        ""
        "NAME"
        "SRCS;HDRS;DEPS;COPTS;LINKOPTS"
        ${ARGN}
    )

    if(NOT ARG_NAME)
        message(FATAL_ERROR "apollo_component: NAME is required")
    endif()

    # Strip leading "lib" and trailing ".so" to get a valid CMake target name
    string(REGEX REPLACE "^lib" "" _tgt_name "${ARG_NAME}")
    string(REGEX REPLACE "\\.so$" "" _tgt_name "${_tgt_name}")

    add_library(${_tgt_name} SHARED ${ARG_SRCS} ${ARG_HDRS})
    set_target_properties(${_tgt_name} PROPERTIES
        OUTPUT_NAME "${_tgt_name}"
        PREFIX "lib"
        SUFFIX ".so"
    )
    if(ARG_DEPS)
        target_link_libraries(${_tgt_name} PRIVATE
            -Wl,--start-group ${ARG_DEPS} -Wl,--end-group)
    endif()
    if(ARG_COPTS)
        target_compile_options(${_tgt_name} PRIVATE ${ARG_COPTS})
    endif()
    if(ARG_LINKOPTS)
        target_link_options(${_tgt_name} PRIVATE ${ARG_LINKOPTS})
        target_link_libraries(${_tgt_name} PRIVATE ${ARG_LINKOPTS})
    endif()
endfunction()

# ──────────────────────────────────────────────
# apollo_plugin(
#     NAME <target_name>           e.g. "liblane_follow_command_processor.so"
#     SRCS <source_files...>
#     HDRS <header_files...>
#     DEPS <dep_targets...>
#     COPTS <compile_options...>
# )
# Builds a shared library (.so) plugin loaded by CyberRT plugin_manager.
# Identical to apollo_component in CMake terms.
# ──────────────────────────────────────────────
function(apollo_plugin)
    cmake_parse_arguments(ARG
        ""
        "NAME"
        "SRCS;HDRS;DEPS;COPTS"
        ${ARGN}
    )

    if(NOT ARG_NAME)
        message(FATAL_ERROR "apollo_plugin: NAME is required")
    endif()

    string(REGEX REPLACE "^lib" "" _tgt_name "${ARG_NAME}")
    string(REGEX REPLACE "\\.so$" "" _tgt_name "${_tgt_name}")

    add_library(${_tgt_name} SHARED ${ARG_SRCS} ${ARG_HDRS})
    set_target_properties(${_tgt_name} PROPERTIES
        OUTPUT_NAME "${_tgt_name}"
        PREFIX "lib"
        SUFFIX ".so"
    )
    if(ARG_DEPS)
        target_link_libraries(${_tgt_name} PRIVATE
            -Wl,--start-group ${ARG_DEPS} -Wl,--end-group)
    endif()
    if(ARG_COPTS)
        target_compile_options(${_tgt_name} PRIVATE ${ARG_COPTS})
    endif()
endfunction()

# ──────────────────────────────────────────────
# apollo_grpc_library(
#     NAME <target_name>
#     SRCS <proto_files...>
#     DEPS <proto_dep_targets...>
# )
# Generates C++ gRPC stubs from .proto service definitions.
# ──────────────────────────────────────────────
function(apollo_grpc_library)
    cmake_parse_arguments(ARG
        ""
        "NAME"
        "SRCS;DEPS"
        ${ARGN}
    )

    if(NOT ARG_NAME)
        message(FATAL_ERROR "apollo_grpc_library: NAME is required")
    endif()

    set(_generated_srcs)
    set(_generated_hdrs)

    foreach(_proto_file ${ARG_SRCS})
        get_filename_component(_proto_name ${_proto_file} NAME_WE)
        get_filename_component(_proto_abs ${_proto_file} ABSOLUTE)

        file(RELATIVE_PATH _proto_rel ${CMAKE_SOURCE_DIR} ${_proto_abs})
        get_filename_component(_proto_rel_dir ${_proto_rel} DIRECTORY)

        set(_grpc_cc "${CMAKE_BINARY_DIR}/${_proto_rel_dir}/${_proto_name}.grpc.pb.cc")
        set(_grpc_h  "${CMAKE_BINARY_DIR}/${_proto_rel_dir}/${_proto_name}.grpc.pb.h")

        add_custom_command(
            OUTPUT ${_grpc_cc} ${_grpc_h}
            COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_BINARY_DIR}/${_proto_rel_dir}"
            COMMAND protobuf::protoc
                --grpc_out=${CMAKE_BINARY_DIR}
                --plugin=protoc-gen-grpc=$<TARGET_FILE:grpc_cpp_plugin>
                -I${CMAKE_SOURCE_DIR}
                -I${Protobuf_INCLUDE_DIR}
                ${_proto_abs}
            DEPENDS ${_proto_abs}
            COMMENT "Generating gRPC C++ for ${_proto_rel}"
            VERBATIM
        )
        list(APPEND _generated_srcs ${_grpc_cc})
        list(APPEND _generated_hdrs ${_grpc_h})
    endforeach()

    add_library(${ARG_NAME} OBJECT ${_generated_srcs} ${_generated_hdrs})
    target_include_directories(${ARG_NAME} PUBLIC ${CMAKE_BINARY_DIR})
    target_link_libraries(${ARG_NAME} PUBLIC grpc++ protobuf::libprotobuf)

    if(ARG_DEPS)
        target_link_libraries(${ARG_NAME} PUBLIC ${ARG_DEPS})
    endif()
endfunction()

# ──────────────────────────────────────────────
# apollo_proto_library(
#     NAME <target_name>
#     SRCS <proto_files...>
#     DEPS <proto_dep_targets...>
# )
# Generates C++ code from .proto files and creates a library target.
# ──────────────────────────────────────────────
function(apollo_proto_library)
    cmake_parse_arguments(ARG
        ""
        "NAME"
        "SRCS;DEPS"
        ${ARGN}
    )

    if(NOT ARG_NAME)
        message(FATAL_ERROR "apollo_proto_library: NAME is required")
    endif()

    set(_generated_srcs)
    set(_generated_hdrs)

    foreach(_proto_file ${ARG_SRCS})
        get_filename_component(_proto_name ${_proto_file} NAME_WE)
        get_filename_component(_proto_abs ${_proto_file} ABSOLUTE)
        get_filename_component(_proto_dir ${_proto_abs} DIRECTORY)

        # Compute path relative to source root for output placement
        file(RELATIVE_PATH _proto_rel ${CMAKE_SOURCE_DIR} ${_proto_abs})
        get_filename_component(_proto_rel_dir ${_proto_rel} DIRECTORY)

        set(_pb_cc "${CMAKE_BINARY_DIR}/${_proto_rel_dir}/${_proto_name}.pb.cc")
        set(_pb_h  "${CMAKE_BINARY_DIR}/${_proto_rel_dir}/${_proto_name}.pb.h")

        add_custom_command(
            OUTPUT ${_pb_cc} ${_pb_h}
            COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_BINARY_DIR}/${_proto_rel_dir}"
            COMMAND protobuf::protoc
                --cpp_out=${CMAKE_BINARY_DIR}
                -I${CMAKE_SOURCE_DIR}
                -I${Protobuf_INCLUDE_DIR}
                ${_proto_abs}
            DEPENDS ${_proto_abs}
            COMMENT "Generating protobuf C++ for ${_proto_rel}"
            VERBATIM
        )

        list(APPEND _generated_srcs ${_pb_cc})
        list(APPEND _generated_hdrs ${_pb_h})
    endforeach()

    add_library(${ARG_NAME} STATIC ${_generated_srcs} ${_generated_hdrs})
    set_target_properties(${ARG_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    target_include_directories(${ARG_NAME} PUBLIC ${CMAKE_BINARY_DIR})
    target_link_libraries(${ARG_NAME} PUBLIC protobuf::libprotobuf)

    if(ARG_DEPS)
        # Ensure proto deps are generated before compiling this proto
        add_dependencies(${ARG_NAME} ${ARG_DEPS})
        target_link_libraries(${ARG_NAME} PUBLIC ${ARG_DEPS})
    endif()
endfunction()
