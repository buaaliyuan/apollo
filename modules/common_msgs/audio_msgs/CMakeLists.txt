# audio_msgs proto targets
apollo_proto_library(NAME audio_common_cc_proto SRCS audio_common.proto)
apollo_proto_library(NAME audio_event_cc_proto SRCS audio_event.proto
    DEPS audio_common_cc_proto header_cc_proto pose_cc_proto)
apollo_proto_library(NAME audio_cc_proto SRCS audio.proto
    DEPS audio_common_cc_proto geometry_cc_proto header_cc_proto)
