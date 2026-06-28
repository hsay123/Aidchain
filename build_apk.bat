@echo off
echo ========================================
echo    Flutter APK Builder for AidChain
echo ========================================
echo.

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Flutter is not installed or not in PATH
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install
    echo.
    pause
    exit /b 1
)

echo Flutter found! Starting build process...
echo.

REM Clean the project
echo Step 1: Cleaning project...
flutter clean
if %errorlevel% neq 0 (
    echo ERROR: Failed to clean project
    pause
    exit /b 1
)

REM Get dependencies
echo Step 2: Getting dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Failed to get dependencies
    pause
    exit /b 1
)

echo.
echo Step 3: Building APK...
echo Choose build type:
echo 1. Debug APK (faster, larger size)
echo 2. Release APK (optimized, smaller size)
echo 3. Split APKs (recommended for production)
echo.
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" (
    echo Building Debug APK...
    flutter build apk --debug
    set apk_path=build\app\outputs\flutter-apk\app-debug.apk
) else if "%choice%"=="2" (
    echo Building Release APK...
    flutter build apk --release
    set apk_path=build\app\outputs\flutter-apk\app-release.apk
) else if "%choice%"=="3" (
    echo Building Split APKs...
    flutter build apk --split-per-abi --release
    set apk_path=build\app\outputs\flutter-apk\
) else (
    echo Invalid choice. Building Release APK by default...
    flutter build apk --release
    set apk_path=build\app\outputs\flutter-apk\app-release.apk
)

if %errorlevel% neq 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo           BUILD COMPLETED!
echo ========================================
echo.

if "%choice%"=="3" (
    echo Split APKs created in: %apk_path%
    echo Files created:
    dir /b "%apk_path%*.apk"
) else (
    echo APK created at: %apk_path%
    if exist "%apk_path%" (
        echo File size: 
        for %%A in ("%apk_path%") do echo %%~zA bytes
    )
)

echo.
echo To install on device:
echo 1. Copy the APK file(s) to your Android device
echo 2. Enable "Install from unknown sources" in device settings
echo 3. Install the APK
echo.
echo Or use ADB to install:
echo adb install "%apk_path%"
echo.
pause
