#!/bin/sh
#
# make_release_archive.sh
#
# Build a LeoRM source release archive with generated HeaderDoc output.
#
# Usage:
#   Tools/make_release_archive.sh v0.1.2-quality-gates
#

set -eu

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="${1:-}"

if [ -z "$VERSION" ]; then
    echo "error: release version argument missing." >&2
    echo "usage: Tools/make_release_archive.sh v0.1.2-quality-gates" >&2
    exit 1
fi

case "$VERSION" in
    v*)
        ;;
    *)
        echo "error: release version should start with v." >&2
        exit 1
        ;;
esac

cd "$ROOT_DIR"

COMMIT="$(git rev-parse HEAD)"
SHORT_COMMIT="$(git rev-parse --short HEAD)"
ARCHIVE_ROOT="LeoRM-$VERSION"
RELEASE_DIR="$ROOT_DIR/Build/Release"
STAGING_DIR="$RELEASE_DIR/$ARCHIVE_ROOT"
ARCHIVE_PATH="$RELEASE_DIR/$ARCHIVE_ROOT.tar.gz"
MANIFEST_PATH="$STAGING_DIR/RELEASE-MANIFEST.txt"

if [ -n "$(git status --short)" ]; then
    echo "error: working tree is not clean." >&2
    git status --short >&2
    exit 1
fi

echo "LeoRM release archive build"
echo "Version: $VERSION"
echo "Commit:  $COMMIT"

make clean
make
make smoke
make apidocs

rm -rf "$STAGING_DIR" "$ARCHIVE_PATH"
mkdir -p "$RELEASE_DIR"

git archive --format=tar --prefix="$ARCHIVE_ROOT/" HEAD | tar -C "$RELEASE_DIR" -xf -

mkdir -p "$STAGING_DIR/Documentation"
cp -R "$ROOT_DIR/Build/HeaderDoc/raw" "$STAGING_DIR/Documentation/HeaderDoc"

cat > "$MANIFEST_PATH" <<MANIFEST
LeoRM Release Manifest
======================

Version:
  $VERSION

Commit:
  $COMMIT

Short commit:
  $SHORT_COMMIT

Target platform:
  Mac OS X 10.5.8 Leopard
  PowerPC
  MacOSX10.5.sdk
  Xcode 3.1.4-compatible toolchain
  Foundation.framework
  libsqlite3
  manual retain/release

Required verification path:
  make clean
  make
  make smoke
  make apidocs

Leak verification path:
  make leaks-check

Included:
  README.md
  Makefile
  Sources/
  Tests/
  Examples/
  Tools/
  docs/
  Documentation/HeaderDoc/
  RELEASE-MANIFEST.txt

Excluded:
  .git/
  Build/*.o
  Build/libLeoRM.a
  local test databases
  temporary build products
  user-local editor or Xcode state

Notes:
  Generated HeaderDoc HTML is included in this release archive.
  Generated HeaderDoc HTML is intentionally not committed to main.
  The static library is intentionally not included as a prebuilt binary artifact.
  Consumers should build from source on the target platform.
MANIFEST

(
    cd "$RELEASE_DIR"
    tar -czf "$ARCHIVE_PATH" "$ARCHIVE_ROOT"
)

echo "Release staging directory:"
echo "  $STAGING_DIR"

echo "Release archive:"
echo "  $ARCHIVE_PATH"

echo "Archive contents preview:"
tar -tzf "$ARCHIVE_PATH" | head -40

echo "LeoRM release archive build OK"
