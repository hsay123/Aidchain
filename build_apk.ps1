# Flutter APK Builder for AidChain
# PowerShell Script

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    Flutter APK Builder for AidChain" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is installed
try {
    $flutterVersion = flutter --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Flutter not found"
    }
    Write-Host "Flutter found! Starting build process..." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Flutter is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Flutter from: https://flutter.dev/docs/get-started/install" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Clean the project
Write-Host "Step 1: Cleaning project..." -ForegroundColor Yellow
flutter clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to clean project" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Get dependencies
Write-Host "Step 2: Getting dependencies..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to get dependencies" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Step 3: Building APK..." -ForegroundColor Yellow
Write-Host "Choose build type:" -ForegroundColor White
Write-Host "1. Debug APK (faster, larger size)" -ForegroundColor Gray
Write-Host "2. Release APK (optimized, smaller size)" -ForegroundColor Gray
Write-Host "3. Split APKs (recommended for production)" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host "Enter your choice (1-3)"

$apkPath = ""

switch ($choice) {
    "1" {
        Write-Host "Building Debug APK..." -ForegroundColor Green
        flutter build apk --debug
        $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
    }
    "2" {
        Write-Host "Building Release APK..." -ForegroundColor Green
        flutter build apk --release
        $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
    }
    "3" {
        Write-Host "Building Split APKs..." -ForegroundColor Green
        flutter build apk --split-per-abi --release
        $apkPath = "build\app\outputs\flutter-apk\"
    }
    default {
        Write-Host "Invalid choice. Building Release APK by default..." -ForegroundColor Yellow
        flutter build apk --release
        $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
    }
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Build failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "           BUILD COMPLETED!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($choice -eq "3") {
    Write-Host "Split APKs created in: $apkPath" -ForegroundColor Green
    Write-Host "Files created:" -ForegroundColor White
    Get-ChildItem -Path $apkPath -Filter "*.apk" | ForEach-Object {
        Write-Host "  - $($_.Name) ($([math]::Round($_.Length / 1MB, 2)) MB)" -ForegroundColor Gray
    }
} else {
    Write-Host "APK created at: $apkPath" -ForegroundColor Green
    if (Test-Path $apkPath) {
        $fileSize = (Get-Item $apkPath).Length
        $fileSizeMB = [math]::Round($fileSize / 1MB, 2)
        Write-Host "File size: $fileSizeMB MB" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "To install on device:" -ForegroundColor Yellow
Write-Host "1. Copy the APK file(s) to your Android device" -ForegroundColor White
Write-Host "2. Enable 'Install from unknown sources' in device settings" -ForegroundColor White
Write-Host "3. Install the APK" -ForegroundColor White
Write-Host ""
Write-Host "Or use ADB to install:" -ForegroundColor Yellow
if ($choice -eq "3") {
    Write-Host "adb install '$apkPath\app-arm64-v8a-release.apk'" -ForegroundColor Gray
} else {
    Write-Host "adb install '$apkPath'" -ForegroundColor Gray
}
Write-Host ""
Read-Host "Press Enter to exit"
