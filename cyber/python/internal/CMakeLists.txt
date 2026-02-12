add_library(py_cyber MODULE py_cyber.cc)
target_link_libraries(py_cyber PRIVATE cyber tcmalloc)
target_include_directories(py_cyber PUBLIC ${PYTHON_INCLUDE_DIRS})
set_target_properties(py_cyber PROPERTIES
    PREFIX ""
    OUTPUT_NAME "_cyber_wrapper"
)

add_library(py_parameter MODULE py_parameter.cc)
target_link_libraries(py_parameter PRIVATE cyber)
target_include_directories(py_parameter PUBLIC ${PYTHON_INCLUDE_DIRS})
set_target_properties(py_parameter PROPERTIES
    PREFIX ""
    OUTPUT_NAME "_cyber_parameter_wrapper"
)

add_library(py_time MODULE py_time.cc)
target_link_libraries(py_time PRIVATE cyber)
target_include_directories(py_time PUBLIC ${PYTHON_INCLUDE_DIRS})
set_target_properties(py_time PROPERTIES
    PREFIX ""
    OUTPUT_NAME "_cyber_time_wrapper"
)

add_library(py_timer MODULE py_timer.cc)
target_link_libraries(py_timer PRIVATE cyber)
target_include_directories(py_timer PUBLIC ${PYTHON_INCLUDE_DIRS})
set_target_properties(py_timer PROPERTIES
    PREFIX ""
    OUTPUT_NAME "_cyber_timer_wrapper"
)

add_library(py_record MODULE py_record.cc)
target_link_libraries(py_record PRIVATE cyber)
target_include_directories(py_record PUBLIC ${PYTHON_INCLUDE_DIRS})
set_target_properties(py_record PROPERTIES
    PREFIX ""
    OUTPUT_NAME "_cyber_record_wrapper"
)

install(TARGETS py_cyber py_parameter py_time py_timer py_record
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)