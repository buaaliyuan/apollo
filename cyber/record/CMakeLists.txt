# ============================================================================
# cyber/record/CMakeLists.txt
# Mirrors: cyber/record/BUILD
# ============================================================================

apollo_cc_library(
    NAME cyber_record
    SRCS
        header_builder.cc
        record_reader.cc
        record_viewer.cc
        record_writer.cc
        file/record_file_base.cc
        file/record_file_reader.cc
        file/record_file_writer.cc
    HDRS
        header_builder.h
        record_base.h
        record_message.h
        record_reader.h
        record_viewer.h
        record_writer.h
        file/record_file_base.h
        file/record_file_reader.h
        file/record_file_writer.h
        file/section.h
    DEPS
        cyber_common
        record_cc_proto
        cyber_time
        protobuf::libprotobuf
        cyber_message
)

apollo_cc_test(NAME record_file_test   SRCS file/record_file_test.cc   DEPS cyber record_cc_proto)
apollo_cc_test(NAME record_reader_test SRCS record_reader_test.cc DEPS cyber record_cc_proto)
apollo_cc_test(NAME record_viewer_test SRCS record_viewer_test.cc DEPS cyber record_cc_proto)
