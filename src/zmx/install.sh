#!/usr/bin/env bash
set -euo pipefail

# Feature: zmx — session persistence for terminal processes
# https://zmx.sh

ZMX_VERSION="${VERSION:-0.6.0}"

# Validate version format
if ! echo "${ZMX_VERSION}" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    echo "(!) Invalid version format: '${ZMX_VERSION}'. Expected semver (e.g. '0.6.0')."
    exit 1
fi

echo "Installing zmx v${ZMX_VERSION}..."

# Ensure required tools are available
ensure_deps() {
    if command -v apt-get > /dev/null 2>&1; then
        if ! command -v curl > /dev/null 2>&1 && ! command -v wget > /dev/null 2>&1; then
            apt-get update -y && apt-get install -y --no-install-recommends ca-certificates curl
        fi
    elif command -v apk > /dev/null 2>&1; then
        if ! command -v curl > /dev/null 2>&1 && ! command -v wget > /dev/null 2>&1; then
            apk add --no-cache curl ca-certificates
        fi
    fi
}

ensure_deps

# Determine architecture
ARCH="$(uname -m)"
case "${ARCH}" in
    x86_64|amd64)
        ZMX_ARCH="x86_64"
        ;;
    aarch64|arm64)
        ZMX_ARCH="aarch64"
        ;;
    *)
        echo "(!) Unsupported architecture: ${ARCH}"
        exit 1
        ;;
esac

# Determine OS
OS="$(uname -s)"
case "${OS}" in
    Linux)
        ZMX_OS="linux"
        ;;
    Darwin)
        ZMX_OS="macos"
        ;;
    *)
        echo "(!) Unsupported OS: ${OS}"
        exit 1
        ;;
esac

DOWNLOAD_URL="https://zmx.sh/a/zmx-${ZMX_VERSION}-${ZMX_OS}-${ZMX_ARCH}.tar.gz"
INSTALL_DIR="/usr/local/bin"

echo "Downloading zmx from ${DOWNLOAD_URL}..."

# Use a temporary directory for download
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

if command -v curl > /dev/null 2>&1; then
    curl -fsSL "${DOWNLOAD_URL}" -o "${TMP_DIR}/zmx.tar.gz"
elif command -v wget > /dev/null 2>&1; then
    wget -q "${DOWNLOAD_URL}" -O "${TMP_DIR}/zmx.tar.gz"
else
    echo "(!) Neither curl nor wget is available. Cannot download zmx."
    exit 1
fi

# Extract with hardened options
tar --no-same-owner --no-same-permissions -xzf "${TMP_DIR}/zmx.tar.gz" -C "${TMP_DIR}"

# Find the zmx binary (may be in a subdirectory or at the top level)
ZMX_BIN="$(find "${TMP_DIR}" -name 'zmx' -type f -perm -u+x | head -n1)"
if [ -z "${ZMX_BIN}" ]; then
    # Try without execute permission check (tar might not preserve it)
    ZMX_BIN="$(find "${TMP_DIR}" -name 'zmx' -type f | head -n1)"
fi

if [ -z "${ZMX_BIN}" ]; then
    echo "(!) Could not find zmx binary in downloaded archive."
    exit 1
fi

install -m 0755 "${ZMX_BIN}" "${INSTALL_DIR}/zmx"

echo "zmx v${ZMX_VERSION} installed to ${INSTALL_DIR}/zmx"
zmx version
