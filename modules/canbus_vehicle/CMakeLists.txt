# ============================================================================
# modules/canbus_vehicle/CMakeLists.txt
# Vehicle CAN-bus plugins (one shared library per vehicle)
# ============================================================================

# Each vehicle follows the same pattern:
#   1. Proto message library  (vehicle/proto/vehicle.proto)
#   2. Static library          (all *.cc + protocol/*.cc)
#   3. Shared plugin library   (factory .so loaded by canbus module)

# Common deps shared by all vehicle plugins
set(_VEHICLE_COMMON_DEPS
    cyber
    apollo_canbus
    apollo_drivers_canbus
    adapter_gflags
    status
    chassis_cc_proto
    error_code_cc_proto
    control_cmd_cc_proto
    canbus_conf_cc_proto
    vehicle_parameter_cc_proto
)

# ─────────────────────────────────────────────
# Helper macro: define a vehicle plugin
# ─────────────────────────────────────────────
macro(apollo_vehicle_plugin VEHICLE_NAME PROTO_DEPS EXTRA_DEPS)
    # Protos
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${VEHICLE_NAME}/proto/${VEHICLE_NAME}.proto")
        apollo_proto_library(
            NAME ${VEHICLE_NAME}_cc_proto
            SRCS ${VEHICLE_NAME}/proto/${VEHICLE_NAME}.proto
        )
    endif()

    # Collect all .cc in vehicle dir + protocol subdir (exclude tests)
    file(GLOB _${VEHICLE_NAME}_srcs
        ${VEHICLE_NAME}/${VEHICLE_NAME}_controller.cc
        ${VEHICLE_NAME}/${VEHICLE_NAME}_message_manager.cc
        ${VEHICLE_NAME}/${VEHICLE_NAME}_vehicle_factory.cc
    )
    file(GLOB _${VEHICLE_NAME}_proto_srcs
        ${VEHICLE_NAME}/protocol/*.cc
    )
    # Remove test files
    list(FILTER _${VEHICLE_NAME}_proto_srcs EXCLUDE REGEX "_test\\.cc$")

    apollo_cc_library(
        NAME apollo_canbus_vehicle_${VEHICLE_NAME}
        SRCS ${_${VEHICLE_NAME}_srcs} ${_${VEHICLE_NAME}_proto_srcs}
        DEPS
            ${_VEHICLE_COMMON_DEPS}
            ${VEHICLE_NAME}_cc_proto
            ${PROTO_DEPS}
            ${EXTRA_DEPS}
        COPTS -DMODULE_NAME="${VEHICLE_NAME}"
    )

    apollo_component(
        NAME lib${VEHICLE_NAME}_vehicle_factory_lib.so
        SRCS ${_${VEHICLE_NAME}_srcs} ${_${VEHICLE_NAME}_proto_srcs}
        DEPS
            ${_VEHICLE_COMMON_DEPS}
            ${VEHICLE_NAME}_cc_proto
            ${PROTO_DEPS}
            ${EXTRA_DEPS}
        COPTS -DMODULE_NAME="${VEHICLE_NAME}"
    )
endmacro()

# ─────────────────────────────────────────────
# CH
# ─────────────────────────────────────────────
apollo_vehicle_plugin(ch "" "")

# ─────────────────────────────────────────────
# Demo (same structure as devkit, not in official BUILD list but has sources)
# ─────────────────────────────────────────────
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/demo/demo_controller.cc")
    apollo_proto_library(
        NAME demo_cc_proto
        SRCS demo/proto/demo.proto
    )
    file(GLOB _demo_srcs
        demo/demo_controller.cc
        demo/demo_message_manager.cc
        demo/demo_vehicle_factory.cc
    )
    file(GLOB _demo_proto_srcs demo/protocol/*.cc)
    list(FILTER _demo_proto_srcs EXCLUDE REGEX "_test\\.cc$")
    apollo_cc_library(
        NAME apollo_canbus_vehicle_demo
        SRCS ${_demo_srcs} ${_demo_proto_srcs}
        DEPS ${_VEHICLE_COMMON_DEPS} demo_cc_proto
        COPTS -DMODULE_NAME="demo"
    )
    apollo_component(
        NAME libdemo_vehicle_factory_lib.so
        SRCS ${_demo_srcs} ${_demo_proto_srcs}
        DEPS ${_VEHICLE_COMMON_DEPS} demo_cc_proto
        COPTS -DMODULE_NAME="demo"
    )
endif()

# ─────────────────────────────────────────────
# Devkit
# ─────────────────────────────────────────────
apollo_vehicle_plugin(devkit "" "")

# ─────────────────────────────────────────────
# GE3
# ─────────────────────────────────────────────
apollo_vehicle_plugin(ge3 "" "")

# ─────────────────────────────────────────────
# Gem
# ─────────────────────────────────────────────
apollo_vehicle_plugin(gem "" "")

# ─────────────────────────────────────────────
# Lexus (uses glob for ~55 protocol files)
# ─────────────────────────────────────────────
apollo_vehicle_plugin(lexus "" "")

# ─────────────────────────────────────────────
# Lincoln  (additional deps: kv_db, geometry protos)
# ─────────────────────────────────────────────
apollo_proto_library(
    NAME lincoln_cc_proto
    SRCS lincoln/proto/lincoln.proto
    DEPS vehicle_id_cc_proto geometry_cc_proto chassis_cc_proto
)
file(GLOB _lincoln_srcs
    lincoln/lincoln_controller.cc
    lincoln/lincoln_message_manager.cc
    lincoln/lincoln_vehicle_factory.cc
)
file(GLOB _lincoln_proto_srcs lincoln/protocol/*.cc)
list(FILTER _lincoln_proto_srcs EXCLUDE REGEX "_test\\.cc$")
apollo_cc_library(
    NAME apollo_canbus_vehicle_lincoln
    SRCS ${_lincoln_srcs} ${_lincoln_proto_srcs}
    DEPS
        ${_VEHICLE_COMMON_DEPS}
        lincoln_cc_proto
        kv_db
    COPTS -DMODULE_NAME="lincoln"
)
apollo_component(
    NAME liblincoln_vehicle_factory_lib.so
    SRCS ${_lincoln_srcs} ${_lincoln_proto_srcs}
    DEPS
        ${_VEHICLE_COMMON_DEPS}
        lincoln_cc_proto
        kv_db
    COPTS -DMODULE_NAME="lincoln"
)

# ─────────────────────────────────────────────
# Neolix Edu  (proto imports chassis.proto)
# ─────────────────────────────────────────────
apollo_proto_library(
    NAME neolix_edu_cc_proto
    SRCS neolix_edu/proto/neolix_edu.proto
    DEPS chassis_cc_proto
)
file(GLOB _neolix_edu_srcs
    neolix_edu/neolix_edu_controller.cc
    neolix_edu/neolix_edu_message_manager.cc
    neolix_edu/neolix_edu_vehicle_factory.cc
)
file(GLOB _neolix_edu_proto_srcs neolix_edu/protocol/*.cc)
list(FILTER _neolix_edu_proto_srcs EXCLUDE REGEX "_test\\.cc$")
apollo_cc_library(
    NAME apollo_canbus_vehicle_neolix_edu
    SRCS ${_neolix_edu_srcs} ${_neolix_edu_proto_srcs}
    DEPS
        ${_VEHICLE_COMMON_DEPS}
        neolix_edu_cc_proto
    COPTS -DMODULE_NAME="neolix_edu"
)
apollo_component(
    NAME libneolix_edu_vehicle_factory_lib.so
    SRCS ${_neolix_edu_srcs} ${_neolix_edu_proto_srcs}
    DEPS
        ${_VEHICLE_COMMON_DEPS}
        neolix_edu_cc_proto
    COPTS -DMODULE_NAME="neolix_edu"
)

# ─────────────────────────────────────────────
# Transit  (extra deps: kv_db, vehicle_signal proto)
# ─────────────────────────────────────────────
apollo_vehicle_plugin(transit "vehicle_signal_cc_proto" "kv_db")

# ─────────────────────────────────────────────
# Wey
# ─────────────────────────────────────────────
apollo_vehicle_plugin(wey "" "")

# ─────────────────────────────────────────────
# Zhongyun
# ─────────────────────────────────────────────
apollo_vehicle_plugin(zhongyun "" "")
