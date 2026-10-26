#!/usr/bin/env bash
# Installs Xray-core from the official XTLS releases.
# Usage: install_xray.sh [version]   (e.g. v25.1.30, default: latest)
set -euo pipefail

VERSION="${1:-latest}"

case "$(uname -m)" in
  x86_64|amd64)   ARCH="64" ;;
  aarch64|arm64)  ARCH="arm64-v8a" ;;
  armv7l|armv7)   ARCH="arm32-v7a" ;;
  i386|i686)      ARCH="32" ;;
  s390x)          ARCH="s390x" ;;
  *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

if [ "$VERSION" = "latest" ]; then
  VERSION="$(curl -fsSL https://api.github.com/repos/XTLS/Xray-core/releases/latest \
    | grep -m1 '"tag_name"' | cut -d '"' -f4)"
fi

URL="https://github.com/XTLS/Xray-core/releases/download/${VERSION}/Xray-linux-${ARCH}.zip"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Downloading Xray ${VERSION} (${ARCH})..."
curl -fsSL -o "$TMP/xray.zip" "$URL"
unzip -q "$TMP/xray.zip" -d "$TMP/xray"

install -m 755 "$TMP/xray/xray" /usr/local/bin/xray
mkdir -p /usr/local/share/xray
cp "$TMP/xray/geoip.dat" "$TMP/xray/geosite.dat" /usr/local/share/xray/

echo "Xray ${VERSION} installed to /usr/local/bin/xray"
