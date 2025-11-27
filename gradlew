#!/usr/bin/env sh
set -e
GRADLE_VERSION=7.4.2
GRADLE_HOME="$HOME/.gradle/wrapper/dists/gradle-$GRADLE_VERSION"
GRADLE_BIN="$GRADLE_HOME/bin/gradle"
if [ -x "$GRADLE_BIN" ]; then
  exec "$GRADLE_BIN" "$@"
fi
TMP_DIR="$(mktemp -d)"
ZIP_URL="https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip"
echo "Downloading Gradle $GRADLE_VERSION from $ZIP_URL..."
if command -v curl >/dev/null 2>&1; then
  curl -Ls "$ZIP_URL" -o "$TMP_DIR/gradle.zip"
elif command -v wget >/dev/null 2>&1; then
  wget -q -O "$TMP_DIR/gradle.zip" "$ZIP_URL"
else
  echo "Error: curl or wget required to download Gradle." >&2
  exit 1
fi
mkdir -p "$GRADLE_HOME"
unzip -q "$TMP_DIR/gradle.zip" -d "$TMP_DIR"
# Move extracted files into GRADLE_HOME keeping directory contents
if [ -d "$TMP_DIR/gradle-$GRADLE_VERSION" ]; then
  mv "$TMP_DIR/gradle-$GRADLE_VERSION"/* "$GRADLE_HOME/" || true
else
  # Some environments may extract into a different folder; try to find gradle directory
  FOUND_DIR=$(find "$TMP_DIR" -maxdepth 2 -type d -name "gradle-*" | head -n 1)
  if [ -n "$FOUND_DIR" ]; then
    mv "$FOUND_DIR"/* "$GRADLE_HOME/" || true
  fi
fi
rm -rf "$TMP_DIR"
exec "$GRADLE_HOME/bin/gradle" "$@"
