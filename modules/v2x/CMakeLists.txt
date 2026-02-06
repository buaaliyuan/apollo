# ============================================================================
# modules/v2x/CMakeLists.txt
# ============================================================================

# ── Proto ──
apollo_proto_library(
    NAME fusion_params_cc_proto
    SRCS proto/fusion_params.proto
)

apollo_proto_library(
    NAME v2x_monitor_cc_proto
    SRCS proto/v2x_monitor.proto
)

apollo_proto_library(
    NAME v2x_junction_cc_proto
    SRCS proto/v2x_junction.proto
    DEPS geometry_cc_proto
)

apollo_proto_library(
    NAME v2x_rsi_cc_proto
    SRCS proto/v2x_rsi.proto
    DEPS header_cc_proto
)

apollo_proto_library(
    NAME v2x_obu_rsi_cc_proto
    SRCS proto/v2x_obu_rsi.proto
    DEPS header_cc_proto geometry_cc_proto
)

apollo_proto_library(
    NAME v2x_obu_traffic_light_cc_proto
    SRCS proto/v2x_obu_traffic_light.proto
    DEPS header_cc_proto v2x_traffic_light_cc_proto
)

apollo_proto_library(
    NAME v2x_obstacles_cc_proto
    SRCS proto/v2x_obstacles.proto
    DEPS header_cc_proto error_code_cc_proto perception_obstacle_cc_proto
)

apollo_proto_library(
    NAME v2x_car_status_cc_proto
    SRCS proto/v2x_car_status.proto
    DEPS localization_cc_proto chassis_detail_cc_proto v2x_junction_cc_proto
)

apollo_proto_library(
    NAME v2x_traffic_light_policy_cc_proto
    SRCS proto/v2x_traffic_light_policy.proto
)

# gRPC service protos
apollo_proto_library(
    NAME v2x_service_obu_to_car_cc_proto
    SRCS proto/v2x_service_obu_to_car.proto
    DEPS v2x_obu_traffic_light_cc_proto v2x_monitor_cc_proto
         v2x_obu_rsi_cc_proto v2x_obstacles_cc_proto
)

apollo_proto_library(
    NAME v2x_service_car_to_obu_cc_proto
    SRCS proto/v2x_service_car_to_obu.proto
    DEPS v2x_car_status_cc_proto
)

# gRPC stubs
apollo_grpc_library(
    NAME v2x_service_obu_to_car_cc_grpc
    SRCS proto/v2x_service_obu_to_car.proto
    DEPS v2x_service_obu_to_car_cc_proto
)

apollo_grpc_library(
    NAME v2x_service_car_to_obu_cc_grpc
    SRCS proto/v2x_service_car_to_obu.proto
    DEPS v2x_service_car_to_obu_cc_proto
)

# ── apollo_v2x library ──
apollo_cc_library(
    NAME apollo_v2x
    SRCS
        common/v2x_proxy_gflags.cc
        fusion/apps/common/trans_tools.cc
        fusion/configs/ft_config_manager.cc
        fusion/configs/fusion_tracker_gflags.cc
        fusion/libs/fusion/fusion.cc
        v2x_proxy/app/utils.cc
        v2x_proxy/app/v2x_proxy.cc
        v2x_proxy/obu_interface/grpc_interface/grpc_client.cc
        v2x_proxy/obu_interface/grpc_interface/grpc_server.cc
        v2x_proxy/obu_interface/obu_interface_grpc_impl.cc
        v2x_proxy/os_interface/os_interface.cc
        v2x_proxy/proto_adapter/proto_adapter.cc
    HDRS
        common/v2x_proxy_gflags.h
        fusion/apps/common/ft_definitions.h
        fusion/apps/common/trans_tools.h
        fusion/configs/ft_config_manager.h
        fusion/configs/fusion_tracker_gflags.h
        fusion/libs/common/v2x_object.h
        fusion/libs/fusion/fusion.h
        fusion/libs/fusion/km.h
        v2x_proxy/app/utils.h
        v2x_proxy/app/v2x_proxy.h
        v2x_proxy/obu_interface/grpc_interface/grpc_client.h
        v2x_proxy/obu_interface/grpc_interface/grpc_server.h
        v2x_proxy/obu_interface/obu_interface_abstract_class.h
        v2x_proxy/obu_interface/obu_interface_grpc_impl.h
        v2x_proxy/os_interface/os_interface.h
        v2x_proxy/proto_adapter/proto_adapter.h
    DEPS
        cyber
        adapter_gflags
        common_math
        localization_cc_proto
        perception_camera_cc_proto
        perception_obstacle_cc_proto
        traffic_light_detection_cc_proto
        planning_cc_proto
        v2x_traffic_light_cc_proto
        apollo_map
        apollo_perception_common_base
        fusion_params_cc_proto
        v2x_car_status_cc_proto
        v2x_junction_cc_proto
        v2x_obstacles_cc_proto
        v2x_obu_rsi_cc_proto
        v2x_obu_traffic_light_cc_proto
        v2x_rsi_cc_proto
        v2x_service_car_to_obu_cc_grpc
        v2x_service_obu_to_car_cc_grpc
        Boost::filesystem
        gflags
        grpc++
        absl
        eigen
)

# ── v2x_fusion_component ──
apollo_component(
    NAME libv2x_fusion_component.so
    SRCS fusion/apps/v2x_fusion_component.cc
    HDRS fusion/apps/v2x_fusion_component.h
    DEPS apollo_v2x
)

# ── v2x binary ──
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/v2x_proxy/app/main.cc")
    apollo_cc_binary(
        NAME v2x
        SRCS v2x_proxy/app/main.cc
        DEPS apollo_v2x
    )
endif()
