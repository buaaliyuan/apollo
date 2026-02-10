# ============================================================================
# cyber/python/CMakeLists.txt
# Python C extension wrappers for CyberRT
# Mirrors: cyber/python/internal/BUILD
#
# Builds 5 CPython extension modules (shared libraries) that are imported
# by the cyber_py3/*.py files via importlib:
#   _cyber_wrapper.so           <- py_cyber.cc
#   _cyber_record_wrapper.so    <- py_record.cc
#   _cyber_time_wrapper.so      <- py_time.cc
#   _cyber_timer_wrapper.so     <- py_timer.cc
#   _cyber_parameter_wrapper.so <- py_parameter.cc
# ============================================================================


# Get the Python extension suffix (e.g. .cpython-36m-x86_64-linux-gnu.so)
execute_process(
    COMMAND ${PYTHON_EXECUTABLE} -c
        "import sysconfig; print(sysconfig.get_config_var('EXT_SUFFIX') or '.so')"
    OUTPUT_VARIABLE PYTHON_EXT_SUFFIX
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
message(STATUS "Python extension suffix: ${PYTHON_EXT_SUFFIX}")

# ── Helper macro: build a CPython extension module ────────────────
# Each module is a SHARED library with:
#   - No "lib" prefix (Python expects _cyber_wrapper.so not lib_cyber_wrapper.so)
#   - Links to libcyber.so + Python library
#   - Includes Python headers
macro(cyber_python_extension TARGET_NAME SRC_FILE)
    add_library(${TARGET_NAME} SHARED
        ${CMAKE_CURRENT_SOURCE_DIR}/internal/${SRC_FILE}
    )
    set_target_properties(${TARGET_NAME} PROPERTIES
        PREFIX ""                       # No "lib" prefix
        #SUFFIX "${PYTHON_EXT_SUFFIX}"   # .cpython-36m-x86_64-linux-gnu.so
        OUTPUT_NAME "${TARGET_NAME}"
    )
    target_include_directories(${TARGET_NAME} PRIVATE
        ${PYTHON_INCLUDE_DIRS}
    )
    target_link_libraries(${TARGET_NAME} PRIVATE
        cyber
        ${PYTHON_LIBRARIES}
        ${ARGN}  # extra deps
    )
    # Install the .so into cyber/python/internal/ so that the py files
    # can find them via sys.path manipulation
    install(TARGETS ${TARGET_NAME}
        LIBRARY DESTINATION cyber/python/internal
    )
endmacro()

# ── Build 5 Python C extension modules ────────────────────────────

# 1. _cyber_wrapper (core: node, reader, writer, service, client)
cyber_python_extension(_cyber_wrapper py_cyber.cc)

# 2. _cyber_record_wrapper (record reader/writer)
cyber_python_extension(_cyber_record_wrapper py_record.cc)

# 3. _cyber_time_wrapper (time, rate, duration)
#    Bazel BUILD also links fastrtps
cyber_python_extension(_cyber_time_wrapper py_time.cc
    fastrtps
)

# 4. _cyber_timer_wrapper (timer)
cyber_python_extension(_cyber_timer_wrapper py_timer.cc)

# 5. _cyber_parameter_wrapper (parameter client/server)
#    py_parameter.h includes py_cyber.h, so it needs the same deps as py_cyber
cyber_python_extension(_cyber_parameter_wrapper py_parameter.cc)

# ── Install Python source files ───────────────────────────────────

# cyber_py3 package (the actual Python API)
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/cyber_py3/
    DESTINATION cyber/python/cyber_py3
    FILES_MATCHING
        PATTERN "*.py"
)

# Also install the internal __init__ marker if needed
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cyber_py3/__init__.py
    DESTINATION cyber/python/cyber_py3
)
