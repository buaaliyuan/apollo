#!/usr/bin/env bash
###############################################################################
# install_thirdparty.sh
# ---------------------------------------------------------------------------
# Automatically download, compile, and install all required third-party
# libraries for Apollo's CMake build.
#
# Produces:
#   thirdparty/install/           (headers + libs consumed by ThirdPartyDeps.cmake)
#   thirdparty/grpc-1.30.0/       (gRPC headers)
#   thirdparty/localization_msf/  (pre-built binary package)
#
# Designed to run **inside** the Apollo Docker container.
# Usage:
#   cd /apollo && bash scripts/install_thirdparty.sh [-j <jobs>]
#
# Library versions (from third_party/*/workspace.bzl):
#   Eigen           3.3.7      (header-only)
#   yaml-cpp        0.6.3      (shared lib)
#   CivetWeb        1.11       (shared lib)
#   GoogleTest      1.10.0     (shared lib)
#   ad-rss-lib      1.1.0      (shared lib)
#   gRPC            1.30.0     (static libs – built via Bazel)
#   localization_msf 1.0.0     (pre-built binary)
###############################################################################
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APOLLO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Configurable parallel jobs
JOBS=10
while [[ $# -gt 0 ]]; do
    case "$1" in
        -j) JOBS="$2"; shift 2 ;;
        *)  echo "Unknown option: $1"; exit 1 ;;
    esac
done

# Paths
PREFIX="${APOLLO_ROOT}/thirdparty/install"
SRC_DIR="${APOLLO_ROOT}/thirdparty/src"
DL_DIR="${APOLLO_ROOT}/thirdparty/downloads"

mkdir -p "${PREFIX}"/{include,lib,bin,share/pkgconfig}
mkdir -p "${PREFIX}/lib/pkgconfig"
mkdir -p "${SRC_DIR}" "${DL_DIR}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

# ============================================================================
# Helper: download a tarball if not already cached
# usage: download_archive <url> <sha256> <dest_tar>
# ============================================================================
download_archive() {
    local url="$1" sha256="$2" dest="$3"
    if [[ -f "${dest}" ]]; then
        local actual
        actual=$(sha256sum "${dest}" | awk '{print $1}')
        if [[ "${actual}" == "${sha256}" ]]; then
            log_info "Already cached: $(basename ${dest})"
            return 0
        else
            log_warn "SHA256 mismatch for $(basename ${dest}), re-downloading..."
            rm -f "${dest}"
        fi
    fi
    log_info "Downloading $(basename ${dest}) ..."
    # Try primary URL, fall back to secondary if provided
    if ! curl -fSL --retry 3 --connect-timeout 30 -o "${dest}" "${url}"; then
        log_error "Download failed: ${url}"
        return 1
    fi
    local actual
    actual=$(sha256sum "${dest}" | awk '{print $1}')
    if [[ "${actual}" != "${sha256}" ]]; then
        log_error "SHA256 verification failed for $(basename ${dest})"
        log_error "  Expected: ${sha256}"
        log_error "  Got:      ${actual}"
        rm -f "${dest}"
        return 1
    fi
}

# ============================================================================
# Helper: extract tarball to SRC_DIR
# usage: extract_archive <tarball> <strip_prefix>
# Returns the extracted directory path via stdout
# ============================================================================
extract_archive() {
    local tarball="$1" strip="$2"
    local dest="${SRC_DIR}/${strip}"
    if [[ -d "${dest}" ]]; then
        log_info "Already extracted: ${strip}"
    else
        log_info "Extracting $(basename ${tarball}) ..."
        tar -xf "${tarball}" -C "${SRC_DIR}"
    fi
    # Return path via a global variable (not stdout, to avoid mixing with log_info)
    _EXTRACTED_DIR="${dest}"
}

# ############################################################################
# 1. Eigen 3.3.7 (header-only)
# Source: third_party/eigen3/workspace.bzl
# ############################################################################
install_eigen() {
    log_info "=== Eigen 3.3.7 ==="
    local url="https://github.com/eigenteam/eigen-git-mirror/archive/3.3.7.tar.gz"
    local url2="https://apollo-system.cdn.bcebos.com/archive/6.0/3.3.7.tar.gz"
    local sha="a8d87c8df67b0404e97bcef37faf3b140ba467bc060e2b883192165b319cea8d"
    local tar="${DL_DIR}/eigen-3.3.7.tar.gz"
    local strip="eigen-git-mirror-3.3.7"

    download_archive "${url}" "${sha}" "${tar}" || \
        download_archive "${url2}" "${sha}" "${tar}"

    extract_archive "${tar}" "${strip}"
    local src="${_EXTRACTED_DIR}"

    # Header-only: just copy headers
    if [[ ! -d "${PREFIX}/include/eigen3/Eigen" ]]; then
        mkdir -p "${PREFIX}/include/eigen3"
        cp -r "${src}/Eigen" "${PREFIX}/include/eigen3/"
        cp -r "${src}/unsupported" "${PREFIX}/include/eigen3/"
        cp "${src}/signature_of_eigen3_matrix_library" "${PREFIX}/include/eigen3/"

        # Install cmake config
        mkdir -p "${PREFIX}/share/eigen3/cmake"
        cat > "${PREFIX}/share/eigen3/cmake/Eigen3Config.cmake" <<'EIGENCM'
set(EIGEN3_FOUND TRUE)
set(EIGEN3_VERSION "3.3.7")
get_filename_component(EIGEN3_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/../../../include/eigen3" ABSOLUTE)
set(EIGEN3_INCLUDE_DIRS ${EIGEN3_INCLUDE_DIR})
if(NOT TARGET Eigen3::Eigen)
    add_library(Eigen3::Eigen INTERFACE IMPORTED)
    set_target_properties(Eigen3::Eigen PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${EIGEN3_INCLUDE_DIR}")
endif()
EIGENCM
        cat > "${PREFIX}/share/eigen3/cmake/Eigen3ConfigVersion.cmake" <<'EIGENV'
set(PACKAGE_VERSION "3.3.7")
if("${PACKAGE_FIND_VERSION}" VERSION_GREATER "3.3.7")
    set(PACKAGE_VERSION_COMPATIBLE FALSE)
else()
    set(PACKAGE_VERSION_COMPATIBLE TRUE)
    if("${PACKAGE_FIND_VERSION}" VERSION_EQUAL "3.3.7")
        set(PACKAGE_VERSION_EXACT TRUE)
    endif()
endif()
EIGENV
        cat > "${PREFIX}/share/pkgconfig/eigen3.pc" <<'EIGENPC'
prefix=${pcfiledir}/../..
includedir=${prefix}/include/eigen3

Name: Eigen3
Description: A C++ template library for linear algebra
Version: 3.3.7
Cflags: -I${includedir}
EIGENPC
    fi
    log_info "Eigen 3.3.7 installed (header-only)"
}

# ############################################################################
# 2. yaml-cpp 0.6.3
# Source: third_party/yaml_cpp/workspace.bzl
# ############################################################################
install_yaml_cpp() {
    log_info "=== yaml-cpp 0.6.3 ==="
    local url="https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.3.tar.gz"
    local url2="https://apollo-system.cdn.bcebos.com/archive/6.0/yaml-cpp-0.6.3.tar.gz"
    local sha="77ea1b90b3718aa0c324207cb29418f5bced2354c2e483a9523d98c3460af1ed"
    local tar="${DL_DIR}/yaml-cpp-0.6.3.tar.gz"
    local strip="yaml-cpp-yaml-cpp-0.6.3"

    download_archive "${url}" "${sha}" "${tar}" || \
        download_archive "${url2}" "${sha}" "${tar}"

    extract_archive "${tar}" "${strip}"
    local src="${_EXTRACTED_DIR}"

    if [[ -f "${PREFIX}/lib/libyaml-cpp.so" ]]; then
        log_info "yaml-cpp already installed"
        return 0
    fi

    log_info "Building yaml-cpp ..."
    local build_dir="${src}/build_cmake"
    mkdir -p "${build_dir}"
    cd "${build_dir}"
    cmake .. \
        -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
        -DCMAKE_BUILD_TYPE=Release \
        -DYAML_CPP_BUILD_TESTS=OFF \
        -DYAML_CPP_BUILD_TOOLS=OFF \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    make -j${JOBS}
    make install
    cd "${APOLLO_ROOT}"

    # Also create pkgconfig
    mkdir -p "${PREFIX}/lib/pkgconfig"
    cat > "${PREFIX}/lib/pkgconfig/yaml-cpp.pc" <<EOF
prefix=${PREFIX}
libdir=\${prefix}/lib
includedir=\${prefix}/include

Name: yaml-cpp
Description: A YAML parser and emitter for C++
Version: 0.6.3
Libs: -L\${libdir} -lyaml-cpp
Cflags: -I\${includedir}
EOF
    log_info "yaml-cpp 0.6.3 installed"
}

# ############################################################################
# 3. CivetWeb 1.11
# Source: third_party/civetweb/workspace.bzl + civetweb.BUILD
# ############################################################################
install_civetweb() {
    log_info "=== CivetWeb 1.11 ==="
    local url="https://github.com/civetweb/civetweb/archive/v1.11.tar.gz"
    local url2="https://apollo-system.cdn.bcebos.com/archive/6.0/v1.11.tar.gz"
    local sha="de7d5e7a2d9551d325898c71e41d437d5f7b51e754b242af897f7be96e713a42"
    local tar="${DL_DIR}/civetweb-1.11.tar.gz"
    local strip="civetweb-1.11"

    download_archive "${url}" "${sha}" "${tar}" || \
        download_archive "${url2}" "${sha}" "${tar}"

    extract_archive "${tar}" "${strip}"
    local src="${_EXTRACTED_DIR}"

    if [[ -f "${PREFIX}/lib/libcivetweb-cpp.so" ]]; then
        log_info "CivetWeb already installed"
        return 0
    fi

    log_info "Building CivetWeb ..."

    # Build the C library as shared
    cd "${src}"
    # Build static C core
    gcc -c -fPIC -DUSE_WEBSOCKET -DNO_SSL \
        -I include -I src \
        src/civetweb.c -o civetweb.o

    # Build C++ wrapper and link together as shared lib
    g++ -c -fPIC -DUSE_WEBSOCKET -DNO_SSL \
        -I include -I src \
        -std=c++14 \
        src/CivetServer.cpp -o CivetServer.o

    # Create shared libraries
    gcc -shared -o libcivetweb.so.1.11.0 civetweb.o -lpthread -ldl
    ln -sf libcivetweb.so.1.11.0 libcivetweb.so

    g++ -shared -o libcivetweb-cpp.so.1.11.0 CivetServer.o civetweb.o -lpthread -ldl
    ln -sf libcivetweb-cpp.so.1.11.0 libcivetweb-cpp.so

    # Install
    cp -P libcivetweb.so* "${PREFIX}/lib/"
    cp -P libcivetweb-cpp.so* "${PREFIX}/lib/"
    cp include/civetweb.h "${PREFIX}/include/"
    cp include/CivetServer.h "${PREFIX}/include/"

    # Civetweb CLI binary
    gcc -DUSE_WEBSOCKET -DNO_SSL \
        -I include -I src \
        src/civetweb.c src/main.c \
        -o "${PREFIX}/bin/civetweb" \
        -lpthread -ldl

    rm -f civetweb.o CivetServer.o
    cd "${APOLLO_ROOT}"
    log_info "CivetWeb 1.11 installed"
}

# ############################################################################
# 4. GoogleTest 1.10.0
# Source: third_party/gtest/workspace.bzl
# ############################################################################
install_gtest() {
    log_info "=== GoogleTest 1.10.0 ==="
    local url="https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
    local url2="https://apollo-system.cdn.bcebos.com/archive/6.0/release-1.10.0.tar.gz"
    local sha="9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
    local tar="${DL_DIR}/googletest-1.10.0.tar.gz"
    local strip="googletest-release-1.10.0"

    download_archive "${url}" "${sha}" "${tar}" || \
        download_archive "${url2}" "${sha}" "${tar}"

    extract_archive "${tar}" "${strip}"
    local src="${_EXTRACTED_DIR}"

    if [[ -f "${PREFIX}/lib/libgtest.so" ]]; then
        log_info "GoogleTest already installed"
        return 0
    fi

    log_info "Building GoogleTest ..."
    local build_dir="${src}/build_cmake"
    mkdir -p "${build_dir}"
    cd "${build_dir}"
    cmake .. \
        -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    make -j${JOBS}
    make install
    cd "${APOLLO_ROOT}"
    log_info "GoogleTest 1.10.0 installed"
}

# ############################################################################
# 5. ad-rss-lib 1.1.0
# Source: third_party/ad_rss_lib/workspace.bzl + ad_rss_lib.BUILD
# ############################################################################
install_ad_rss() {
    log_info "=== ad-rss-lib 1.1.0 ==="
    local url="https://github.com/intel/ad-rss-lib/archive/v1.1.0.tar.gz"
    local url2="https://apollo-system.cdn.bcebos.com/archive/6.0/v1.1.0.tar.gz"
    local sha="10c161733a06053f79120f389d2d28208c927eb65759799fb8d7142666b61b9f"
    local tar="${DL_DIR}/ad-rss-lib-1.1.0.tar.gz"
    local strip="ad-rss-lib-1.1.0"

    download_archive "${url}" "${sha}" "${tar}" || \
        download_archive "${url2}" "${sha}" "${tar}"

    extract_archive "${tar}" "${strip}"
    local src="${_EXTRACTED_DIR}"

    if [[ -f "${PREFIX}/lib/libad-rss.so" ]]; then
        log_info "ad-rss-lib already installed"
        return 0
    fi

    log_info "Building ad-rss-lib ..."
    # Build as shared library matching the Bazel BUILD definition
    cd "${src}"

    # Collect all source files (matching ad_rss_lib.BUILD)
    local srcs=(
        src/generated/physics/Acceleration.cpp
        src/generated/physics/CoordinateSystemAxis.cpp
        src/generated/physics/Distance.cpp
        src/generated/physics/DistanceSquared.cpp
        src/generated/physics/Duration.cpp
        src/generated/physics/DurationSquared.cpp
        src/generated/physics/ParametricValue.cpp
        src/generated/physics/Speed.cpp
        src/generated/physics/SpeedSquared.cpp
        src/generated/situation/LateralRelativePosition.cpp
        src/generated/situation/LongitudinalRelativePosition.cpp
        src/generated/situation/SituationType.cpp
        src/generated/state/LateralResponse.cpp
        src/generated/state/LongitudinalResponse.cpp
        src/generated/world/LaneDrivingDirection.cpp
        src/generated/world/LaneSegmentType.cpp
        src/generated/world/ObjectType.cpp
        src/core/RssCheck.cpp
        src/core/RssResponseResolving.cpp
        src/core/RssResponseTransformation.cpp
        src/core/RssSituationChecking.cpp
        src/core/RssSituationExtraction.cpp
        src/physics/Math.cpp
    )

    # Compile each source
    local objs=()
    for s in "${srcs[@]}"; do
        local obj="${s%.cpp}.o"
        g++ -c -fPIC -std=c++14 \
            -I include -I include/generated -I src \
            "${s}" -o "${obj}"
        objs+=("${obj}")
    done

    # Link as shared lib
    g++ -shared -o libad-rss.so.1.1.0 "${objs[@]}"
    ln -sf libad-rss.so.1.1.0 libad-rss.so.1
    ln -sf libad-rss.so.1.1.0 libad-rss.so

    # Install
    cp -P libad-rss.so* "${PREFIX}/lib/"

    # Install headers (matching ad_rss_lib.BUILD install_files)
    local hdr_dest="${PREFIX}/include/ad_rss"
    mkdir -p "${hdr_dest}"
    # Copy all hpp from include/ad_rss/, src/, include/generated/ad_rss/
    find include/ad_rss -name "*.hpp" | while read f; do
        local relpath="${f#include/ad_rss/}"
        mkdir -p "${hdr_dest}/$(dirname ${relpath})"
        cp "${f}" "${hdr_dest}/${relpath}"
    done
    find src -name "*.hpp" | while read f; do
        local relpath="${f#src/}"
        mkdir -p "${hdr_dest}/$(dirname ${relpath})"
        cp "${f}" "${hdr_dest}/${relpath}"
    done
    find include/generated/ad_rss -name "*.hpp" | while read f; do
        local relpath="${f#include/generated/ad_rss/}"
        mkdir -p "${hdr_dest}/$(dirname ${relpath})"
        cp "${f}" "${hdr_dest}/${relpath}"
    done

    rm -f "${objs[@]}" libad-rss.so*
    cd "${APOLLO_ROOT}"
    log_info "ad-rss-lib 1.1.0 installed"
}

# ############################################################################
# 6. gRPC 1.30.0 (static libs + headers)
# Source: WORKSPACE.source – Apollo uses a patched gRPC built via Bazel.
# The Apollo tarball does NOT include submodules (boringssl, abseil, etc.),
# so building from source via CMake requires special handling.
#
# Strategy:
#   a) If pre-built .a files exist in thirdparty_backup/, copy them
#   b) Otherwise, download the full gRPC source with submodules and build
# ############################################################################
install_grpc() {
    log_info "=== gRPC 1.30.0 ==="

    local grpc_lib_dir="${PREFIX}/lib/grpc"
    mkdir -p "${grpc_lib_dir}"

    # Check if already installed
    if [[ -d "${grpc_lib_dir}" ]] && [[ $(ls "${grpc_lib_dir}/"*.a 2>/dev/null | wc -l) -ge 60 ]]; then
        log_info "gRPC static libs already installed ($(ls ${grpc_lib_dir}/*.a | wc -l) archives)"
        _install_grpc_headers
        return 0
    fi

    # Strategy A: Copy from backup if available
    local backup_grpc_lib="${APOLLO_ROOT}/thirdparty_backup/install/lib/grpc"
    if [[ -d "${backup_grpc_lib}" ]] && [[ $(ls "${backup_grpc_lib}/"*.a 2>/dev/null | wc -l) -ge 60 ]]; then
        log_info "Copying pre-built gRPC static libs from thirdparty_backup ..."
        cp "${backup_grpc_lib}/"*.a "${grpc_lib_dir}/"

        # Also copy top-level libs from backup
        for lib in libgrpc++.so libgrpc++.a libgrpc.a libgrpc.so \
                   libgrpc_base_c.a libgrpc_base_c.so \
                   libgpr.a libgpr.so \
                   libaddress_sorting.a libaddress_sorting.so \
                   libgrpc++_base.a libgrpc++_base.so \
                   libgrpc++_codegen_base_src.a \
                   libboringssl_ssl.a libboringssl_crypto.a libcares.a \
                   libgrpc_all.a; do
            if [[ -f "${APOLLO_ROOT}/thirdparty_backup/install/lib/${lib}" ]]; then
                cp -P "${APOLLO_ROOT}/thirdparty_backup/install/lib/${lib}" "${PREFIX}/lib/"
            fi
        done

        # Copy grpc_cpp_plugin from Bazel cache if it exists
        local _plugin
        _plugin=$(find "${APOLLO_ROOT}/.cache" -name "grpc_cpp_plugin" -type f 2>/dev/null | head -1)
        if [[ -n "${_plugin}" ]]; then
            cp "${_plugin}" "${PREFIX}/bin/grpc_cpp_plugin"
            chmod +x "${PREFIX}/bin/grpc_cpp_plugin"
        fi

        _install_grpc_headers
        _create_grpc_fat_archive
        log_info "gRPC 1.30.0 installed from backup"
        return 0
    fi

    # Strategy B: Build from source
    log_info "No pre-built gRPC found. Building from source ..."
    log_info "Downloading full gRPC source with submodules ..."

    local grpc_src="${SRC_DIR}/grpc-1.30.0"
    if [[ ! -d "${grpc_src}/CMakeLists.txt" ]] 2>/dev/null; then
        # Download the Apollo-patched tarball
        local url="https://apollo-system.cdn.bcebos.com/archive/8.0/v1.30.0-apollo.tar.gz"
        local sha="2378b608557a4331c6a6a97f89a9257aee2f8e56a095ce6619eea62e288fcfbe"
        local tar="${DL_DIR}/grpc-1.30.0.tar.gz"
        download_archive "${url}" "${sha}" "${tar}"
        extract_archive "${tar}" "grpc-1.30.0"
    fi

    # Check if submodules are populated; if not, try git
    local need_submodules=false
    for submod in boringssl-with-bazel abseil-cpp; do
        if [[ ! -f "${grpc_src}/third_party/${submod}/CMakeLists.txt" ]]; then
            need_submodules=true
            break
        fi
    done

    if ${need_submodules}; then
        log_warn "gRPC submodules are not populated in the Apollo tarball."
        log_warn "Attempting to clone gRPC 1.30.0 from GitHub with submodules..."

        if command -v git &>/dev/null; then
            local git_src="${SRC_DIR}/grpc-1.30.0-git"
            if [[ ! -d "${git_src}" ]]; then
                git clone --depth 1 --branch v1.30.0 \
                    --recurse-submodules --shallow-submodules \
                    https://github.com/grpc/grpc.git "${git_src}"
            fi
            grpc_src="${git_src}"
        else
            log_error "git not found and gRPC submodules are missing."
            log_error "Please either:"
            log_error "  1) Place pre-built .a files in thirdparty_backup/install/lib/grpc/"
            log_error "  2) Install git and re-run this script"
            return 1
        fi
    fi

    log_info "Building gRPC 1.30.0 via CMake (this may take 15-30 minutes) ..."
    local build_dir="${grpc_src}/build_cmake"
    rm -rf "${build_dir}"
    mkdir -p "${build_dir}"
    cd "${build_dir}"

    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="${PREFIX}/grpc_install" \
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
        -DgRPC_INSTALL=ON \
        -DgRPC_BUILD_TESTS=OFF \
        -DgRPC_BUILD_CSHARP_EXT=OFF \
        -DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF \
        -DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF \
        -DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF \
        -DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF \
        -DgRPC_BUILD_GRPC_PYTHON_PLUGIN=OFF \
        -DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF \
        -DgRPC_ABSL_PROVIDER=module \
        -DgRPC_CARES_PROVIDER=module \
        -DgRPC_PROTOBUF_PROVIDER=package \
        -DgRPC_SSL_PROVIDER=module \
        -DgRPC_ZLIB_PROVIDER=module \
        -DgRPC_RE2_PROVIDER=module \
        -DCMAKE_CXX_STANDARD=14

    make -j${JOBS}
    make install

    # Copy all .a files from the build tree
    find "${build_dir}" -name "*.a" -not -path "*/CMakeFiles/*" | while read lib; do
        cp "${lib}" "${grpc_lib_dir}/$(basename ${lib})"
    done

    # Copy main libs to PREFIX/lib
    for lib in libgrpc++.a libgrpc++.so libgrpc.a libgrpc.so \
               libgpr.a libgpr.so \
               libaddress_sorting.a libaddress_sorting.so; do
        if [[ -f "${PREFIX}/grpc_install/lib/${lib}" ]]; then
            cp -P "${PREFIX}/grpc_install/lib/${lib}" "${PREFIX}/lib/" 2>/dev/null || true
        fi
    done

    # Copy BoringSSL and c-ares to main lib dir
    for lib in libboringssl_ssl.a libboringssl_crypto.a libcares.a; do
        if [[ -f "${grpc_lib_dir}/${lib}" ]]; then
            cp "${grpc_lib_dir}/${lib}" "${PREFIX}/lib/"
        fi
    done

    # Copy grpc_cpp_plugin
    for plugin_path in "${build_dir}/grpc_cpp_plugin" "${PREFIX}/grpc_install/bin/grpc_cpp_plugin"; do
        if [[ -f "${plugin_path}" ]]; then
            cp "${plugin_path}" "${PREFIX}/bin/grpc_cpp_plugin"
            chmod +x "${PREFIX}/bin/grpc_cpp_plugin"
            break
        fi
    done

    cd "${APOLLO_ROOT}"
    _install_grpc_headers
    _create_grpc_fat_archive

    local nlibs
    nlibs=$(ls "${grpc_lib_dir}/"*.a 2>/dev/null | wc -l)
    log_info "gRPC 1.30.0 built and installed (${nlibs} static archives)"
}

# Helper: install gRPC headers (symlink to source)
_install_grpc_headers() {
    local grpc_src=""
    # Search for gRPC source with headers
    for candidate in \
        "${SRC_DIR}/grpc-1.30.0" \
        "${SRC_DIR}/grpc-1.30.0-git" \
        "${APOLLO_ROOT}/thirdparty_backup/grpc-1.30.0"; do
        if [[ -d "${candidate}/include/grpc" ]]; then
            grpc_src="${candidate}"
            break
        fi
    done

    if [[ -n "${grpc_src}" ]]; then
        # Create symlink for ThirdPartyDeps.cmake: thirdparty/grpc-1.30.0
        local link="${APOLLO_ROOT}/thirdparty/grpc-1.30.0"
        if [[ ! -e "${link}" ]]; then
            ln -sf "${grpc_src}" "${link}"
            log_info "gRPC headers linked: ${link} -> ${grpc_src}"
        fi
    else
        log_warn "gRPC source with headers not found"
    fi
}

# Helper: create fat archive from individual .a files
_create_grpc_fat_archive() {
    local grpc_lib_dir="${PREFIX}/lib/grpc"
    if [[ ! -f "${PREFIX}/lib/libgrpc_all.a" ]] && [[ -d "${grpc_lib_dir}" ]]; then
        log_info "Creating fat archive libgrpc_all.a ..."
        local tmpdir
        tmpdir=$(mktemp -d)
        local counter=0
        for a in "${grpc_lib_dir}/"*.a; do
            local subdir="${tmpdir}/$(printf '%04d' ${counter})_$(basename ${a} .a)"
            mkdir -p "${subdir}"
            cd "${subdir}"
            ar x "${a}" 2>/dev/null || true
            counter=$((counter + 1))
        done
        cd "${tmpdir}"
        ar rcs "${PREFIX}/lib/libgrpc_all.a" $(find . -name '*.o' | sort) 2>/dev/null || true
        rm -rf "${tmpdir}"
        cd "${APOLLO_ROOT}"
        log_info "Fat archive created: $(du -sh ${PREFIX}/lib/libgrpc_all.a | cut -f1)"
    fi
}

# ############################################################################
# 7. localization_msf (pre-built binary package)
# Source: third_party/localization_msf/workspace.bzl
# ############################################################################
install_localization_msf() {
    log_info "=== localization_msf 1.0.0 ==="
    local url="https://apollo-pkg-beta.bj.bcebos.com/archive/localization_msf-linux-any-1.0.0.tar.gz"
    local sha="58e11d580060ad9b75d62254eb4f943c510acf5e1eb88868797aa7d77d32299b"
    local tar="${DL_DIR}/localization_msf-1.0.0.tar.gz"

    download_archive "${url}" "${sha}" "${tar}"

    local dest="${APOLLO_ROOT}/thirdparty/localization_msf"
    if [[ -d "${dest}/x86_64" ]]; then
        log_info "localization_msf already installed"
        return 0
    fi

    log_info "Extracting localization_msf ..."
    mkdir -p "${dest}"
    # Tarball contains a top-level localization_msf/ directory; extract to a
    # temp location then move contents up so we get thirdparty/localization_msf/x86_64/
    local tmpdir="${SRC_DIR}/_msf_tmp"
    rm -rf "${tmpdir}"
    mkdir -p "${tmpdir}"
    tar -xf "${tar}" -C "${tmpdir}"
    # Move the inner directory contents up
    if [[ -d "${tmpdir}/localization_msf" ]]; then
        cp -a "${tmpdir}/localization_msf/." "${dest}/"
    else
        cp -a "${tmpdir}/." "${dest}/"
    fi
    rm -rf "${tmpdir}"

    # Source code does #include "localization_msf/sins.h", so create a
    # localization_msf/ sub-dir inside include/ with symlinks to headers.
    local inc_dir="${dest}/x86_64/include"
    if [[ -d "${inc_dir}" ]] && [[ ! -d "${inc_dir}/localization_msf" ]]; then
        mkdir -p "${inc_dir}/localization_msf"
        for hdr in "${inc_dir}"/*.h; do
            ln -sf "../$(basename "${hdr}")" "${inc_dir}/localization_msf/$(basename "${hdr}")"
        done
    fi

    log_info "localization_msf installed at ${dest}"
}

# ############################################################################
# Main
# ############################################################################
main() {
    log_info "============================================"
    log_info "Apollo Third-Party Library Installer"
    log_info "  APOLLO_ROOT: ${APOLLO_ROOT}"
    log_info "  PREFIX:      ${PREFIX}"
    log_info "  JOBS:        ${JOBS}"
    log_info "============================================"

    # Ensure we have build tools
    for tool in cmake gcc g++ ar curl sha256sum; do
        if ! command -v "${tool}" &>/dev/null; then
            log_error "Required tool not found: ${tool}"
            exit 1
        fi
    done

    install_eigen
    install_yaml_cpp
    install_civetweb
    install_gtest
    install_ad_rss
    install_grpc
    install_localization_msf

    log_info "============================================"
    log_info "All third-party libraries installed!"
    log_info ""
    log_info "Installed to: ${PREFIX}"
    log_info ""
    log_info "Contents:"
    log_info "  include/  - eigen3, yaml-cpp, CivetServer, gtest/gmock, ad_rss"
    log_info "  lib/      - .so and .a files"
    log_info "  lib/grpc/ - gRPC static archives"
    log_info "  bin/      - civetweb, grpc_cpp_plugin"
    log_info ""
    log_info "Also:"
    log_info "  thirdparty/grpc-1.30.0/     - gRPC headers"
    log_info "  thirdparty/localization_msf/ - MSF binary package"
    log_info "============================================"
}

main "$@"
