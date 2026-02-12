add_subdirectory(internal)

install(DIRECTORY cyber_py3
    DESTINATION cyber/python
    FILES_MATCHING
    PATTERN "*.py"
)