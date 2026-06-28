# Flutter APK Build Instructions

## Prerequisites

### 1. Install Flutter SDK
1. Download Flutter from: https://flutter.dev/docs/get-started/install
2. Extract to a directory (e.g., `C:\flutter`)
3. Add Flutter to your PATH environment variable:
   - Open System Properties > Environment Variables
   - Add `C:\flutter\bin` to the PATH variable
4. Verify installation: `flutter doctor`

### 2. Install Android Studio
1. Download from: https://developer.android.com/studio
2. Install Android SDK
3. Configure Android SDK tools
4. Accept Android licenses: `flutter doctor --android-licenses`

## Building APK

### Step 1: Verify Project Setup
```bash
# Navigate to your project directory
cd C:\Users\Master\Desktop\aidchain

# Check Flutter installation
flutter doctor

# Get dependencies
flutter pub get
```

### Step 2: Build Debug APK (Quick Testing)
```bash
# Build debug APK
flutter build apk --debug

# The APK will be created at:
# build/app/outputs/flutter-apk/app-debug.apk
```

### Step 3: Build Release APK (Production)
```bash
# Build release APK
flutter build apk --release

# The APK will be created at:
# build/app/outputs/flutter-apk/app-release.apk
```

### Step 4: Build Split APKs (Recommended for Production)
```bash
# Build split APKs for different architectures
flutter build apk --split-per-abi --release

# This creates:
# - app-arm64-v8a-release.apk (64-bit ARM)
# - app-armeabi-v7a-release.apk (32-bit ARM)
# - app-x86_64-release.apk (x86_64)
```

## APK Locations

After building, your APK files will be located at:
- **Debug APK**: `build/app/outputs/flutter-apk/app-debug.apk`
- **Release APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **Split APKs**: `build/app/outputs/flutter-apk/` (multiple files)

## Troubleshooting

### Common Issues:

1. **Flutter not found**:
   - Ensure Flutter is in your PATH
   - Restart terminal/command prompt

2. **Android SDK not found**:
   - Install Android Studio
   - Configure Android SDK
   - Run `flutter doctor --android-licenses`

3. **Build fails**:
   - Run `flutter clean`
   - Run `flutter pub get`
   - Try building again

4. **Permission issues**:
   - Ensure you have write permissions to the project directory

## Testing the APK

1. **Install on device**:
   ```bash
   # Install debug APK
   adb install build/app/outputs/flutter-apk/app-debug.apk
   
   # Install release APK
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

2. **Transfer to device**:
   - Copy APK file to your Android device
   - Enable "Install from unknown sources" in device settings
   - Install the APK

## Production Considerations

### 1. Signing the APK (Required for Play Store)
```bash
# Generate keystore (first time only)
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Configure signing in android/app/build.gradle
# Add signingConfigs and update buildTypes
```

### 2. Update Version
- Update version in `pubspec.yaml`:
  ```yaml
  version: 1.0.0+1  # Increment this for each release
  ```

### 3. Optimize APK Size
- Use `--split-per-abi` for smaller APKs
- Enable R8/ProGuard for code shrinking
- Optimize images and assets

## Quick Commands Summary

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --release

# Build for specific architecture
flutter build apk --target-platform android-arm64 --release

# Build with specific flavor (if configured)
flutter build apk --flavor production --release
```

## File Structure After Build

```
aidchain/
├── build/
│   └── app/
│       └── outputs/
│           └── flutter-apk/
│               ├── app-debug.apk
│               ├── app-release.apk
│               ├── app-arm64-v8a-release.apk
│               ├── app-armeabi-v7a-release.apk
│               └── app-x86_64-release.apk
└── ...
```
