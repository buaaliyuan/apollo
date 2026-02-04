file(GLOB_RECURSE CPPS "*.cc")
file(GLOB_RECURSE HPPS "*.h")
list(FILTER CPPS EXCLUDE REGEX ".*_test.cc$")

add_library(common SHARED 
    ${CPPS}  ${HPPS}
)

target_link_libraries(common PUBLIC
    absl::strings
    absl::optional
    fastrtps
    Eigen3::Eigen
    nlohmann_json
    osqp::osqp
    sqlite3
    common_msg
)
set_target_properties(common PROPERTIES POSITION_INDEPENDENT_CODE ON)