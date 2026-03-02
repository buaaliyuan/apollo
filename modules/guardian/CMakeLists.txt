add_library(guardian_component 
SHARED
    guardian_component.cc
)

target_link_libraries(guardian_component
  PRIVATE
    cyber
    modules_common
    msg_proto
)

target_compile_definitions(guardian_component
  PRIVATE
    MODULE_NAME="guardian"
)

install(TARGETS guardian_component
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)