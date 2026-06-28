#!/bin/bash

# AidChain APK Builder for Linux
# This script automates the entire process of building an APK from your Flutter project

set -e  # Exit on any error

echo "========================================="
echo "    AidChain APK Builder for Linux      "
echo "========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${CYAN}$1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Get project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

print_status "Working in directory: $PROJECT_DIR"

# Set up Android SDK environment
export ANDROID_HOME="$PROJECT_DIR/android-sdk"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

print_status "Step 1: Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    if command -v snap &> /dev/null && snap list flutter &> /dev/null; then
        print_success "Flutter found via snap"
        FLUTTER_CMD="snap run flutter"
    else
        print_error "Flutter is not installed or not in PATH"
        print_error "Please install Flutter from: https://flutter.dev/docs/get-started/install"
        exit 1
    fi
else
    print_success "Flutter found in PATH"
    FLUTTER_CMD="flutter"
fi

# Check Flutter version
print_status "Flutter version:"
$FLUTTER_CMD --version

print_status "Step 2: Setting up Android SDK..."
if [ ! -d "$ANDROID_HOME" ]; then
    print_status "Android SDK not found. Downloading and setting up..."
    
    # Download Android command line tools
    if [ ! -f "commandlinetools-linux-11076708_latest.zip" ]; then
        print_status "Downloading Android command line tools..."
        wget -q "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
    fi
    
    # Extract and set up
    print_status "Extracting Android SDK tools..."
    unzip -q commandlinetools-linux-11076708_latest.zip
    mkdir -p android-sdk/cmdline-tools
    mv cmdline-tools android-sdk/cmdline-tools/latest
    
    print_status "Accepting Android SDK licenses..."
    yes | sdkmanager --licenses > /dev/null 2>&1
    
    print_status "Installing required Android SDK components..."
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" > /dev/null 2>&1
    
    # Clean up
    rm -f commandlinetools-linux-11076708_latest.zip
    
    print_success "Android SDK setup complete"
else
    print_success "Android SDK already configured"
fi

print_status "Step 3: Checking Flutter doctor..."
$FLUTTER_CMD doctor

print_status "Step 4: Cleaning project..."
$FLUTTER_CMD clean

print_status "Step 5: Getting dependencies..."
$FLUTTER_CMD pub get

print_status "Step 6: Building APK..."
echo ""
echo "Choose build type:"
echo "1. Debug APK (faster, larger size, for testing)"
echo "2. Release APK (optimized, smaller size, for production)"
echo "3. Split APKs (recommended for production, creates multiple APKs for different architectures)"
echo ""

while true; do
    read -p "Enter your choice (1-3): " choice
    case $choice in
        1)
            print_status "Building Debug APK..."
            $FLUTTER_CMD build apk --debug
            APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
            break
            ;;
        2)
            print_status "Building Release APK..."
            $FLUTTER_CMD build apk --release
            APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
            break
            ;;
        3)
            print_status "Building Split APKs..."
            $FLUTTER_CMD build apk --split-per-abi --release
            APK_PATH="build/app/outputs/flutter-apk/"
            break
            ;;
        *)
            print_warning "Invalid choice. Please enter 1, 2, or 3."
            ;;
    esac
done

echo ""
print_success "========================================="
print_success "           BUILD COMPLETED!            "
print_success "========================================="
echo ""

if [ "$choice" = "3" ]; then
    print_success "Split APKs created in: $APK_PATH"
    print_status "Files created:"
    ls -la "$APK_PATH"*.apk 2>/dev/null || print_warning "APK files not found"
else
    if [ -f "$APK_PATH" ]; then
        print_success "APK created at: $APK_PATH"
        APK_SIZE=$(stat -f%z "$APK_PATH" 2>/dev/null || stat -c%s "$APK_PATH" 2>/dev/null || echo "unknown")
        print_status "File size: $APK_SIZE bytes"
    else
        print_error "APK file not found at expected location: $APK_PATH"
        print_status "Checking build directory..."
        find build/ -name "*.apk" 2>/dev/null || print_warning "No APK files found in build directory"
    fi
fi

echo ""
print_status "========================================="
print_status "         INSTALLATION INSTRUCTIONS      "
print_status "========================================="
echo ""
print_status "To install on Android device:"
print_status "1. Copy the APK file(s) to your Android device"
print_status "2. Enable 'Install from unknown sources' in device settings"
print_status "3. Install the APK by tapping on it"
echo ""
print_status "Or use ADB to install directly:"
if [ "$choice" = "3" ]; then
    print_status "adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk  # For 64-bit ARM devices"
    print_status "adb install build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk  # For 32-bit ARM devices"
else
    print_status "adb install $APK_PATH"
fi
echo ""
print_status "========================================="
print_status "         PUBLISHING INFORMATION         "
print_status "========================================="
echo ""
print_status "For Google Play Store publishing:"
print_status "1. You'll need to sign the APK with a release key (not debug key)"
print_status "2. Update the version number in pubspec.yaml before each release"
print_status "3. Test the APK thoroughly on different devices"
print_status "4. Consider using Split APKs for smaller download sizes"
echo ""
print_success "Build process complete! Your APK is ready for testing and distribution." 