#!/bin/bash

# Quick APK Builder - Builds release APK directly
set -e

echo "========================================="
echo "      Quick Release APK Builder         "
echo "========================================="

# Set up environment
export ANDROID_HOME="$(pwd)/android-sdk"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

# Check if Flutter is available
if command -v flutter &> /dev/null; then
    FLUTTER_CMD="flutter"
elif command -v snap &> /dev/null && snap list flutter &> /dev/null; then
    FLUTTER_CMD="snap run flutter"
else
    echo "Error: Flutter not found. Please install Flutter first."
    exit 1
fi

echo "Cleaning project..."
$FLUTTER_CMD clean

echo "Getting dependencies..."
$FLUTTER_CMD pub get

echo "Building release APK..."
# Use flags to handle build issues
$FLUTTER_CMD build apk --release --android-skip-build-dependency-validation --no-tree-shake-icons

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

if [ -f "$APK_PATH" ]; then
    echo "========================================="
    echo "✓ SUCCESS: APK built successfully!"
    echo "========================================="
    echo "APK location: $APK_PATH"
    echo "File size: $(stat -c%s "$APK_PATH" 2>/dev/null || echo "unknown") bytes"
    echo ""
    echo "To install: adb install $APK_PATH"
    echo "Or copy the APK file to your Android device and install manually."
else
    echo "Error: APK not found at expected location"
    find build/ -name "*.apk" 2>/dev/null || echo "No APK files found"
fi 