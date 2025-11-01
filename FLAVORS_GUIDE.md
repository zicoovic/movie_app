# Flavors Guide - Dev & Prod

This app has **2 flavors** configured: `dev` and `prod`

## What's Different Between Flavors?

| Feature | Dev Flavor | Prod Flavor |
|---------|-----------|-------------|
| **App Name** | Movie App Dev | Movie App |
| **Package ID** | com.example.movie_app.dev | com.example.movie_app |
| **Install Together** | ✅ Yes - can run both on same device | ✅ Yes |

## How to Run Each Flavor

### ✅ Option 1: Using VS Code Run & Debug (EASIEST!)

1. Open VS Code
2. Go to **"Run and Debug"** panel (Ctrl+Shift+D or Cmd+Shift+D)
3. Click the dropdown at the top and select:
   - **"Dev Flavor"** - Run development version
   - **"Prod Flavor"** - Run production version
4. Click the green play button ▶️
5. App will run on your connected device/emulator!

### Option 2: Using Terminal

**Run Dev Flavor:**
```bash
flutter run --flavor dev --dart-define=FLAVOR=dev
```

**Run Prod Flavor:**
```bash
flutter run --flavor prod --dart-define=FLAVOR=prod
```

**Build APK for Dev:**
```bash
flutter build apk --flavor dev --dart-define=FLAVOR=dev
```

**Build APK for Prod:**
```bash
flutter build apk --flavor prod --dart-define=FLAVOR=prod
```

## Visual Differences

When you install both flavors, you'll see:
- **Movie App Dev** - Development version (has .dev package suffix)
- **Movie App** - Production version

Both apps can run simultaneously on the same device with separate data!

## Best Practice: Single main.dart

✅ **We use a SINGLE `main.dart` file** for both flavors (industry standard)

Instead of creating separate `main_dev.dart` and `main_prod.dart` files, we use:
- **`--dart-define=FLAVOR=dev/prod`** to pass the flavor at runtime
- **`String.fromEnvironment('FLAVOR')`** to read the flavor in code

**Why this is better:**
- ✅ No code duplication
- ✅ Single source of truth
- ✅ Easier to maintain
- ✅ Industry standard approach (used by Google, Airbnb, etc.)

## Files Created

### Entry Point:
- `lib/main.dart` - Single entry point for all flavors (uses environment variables)

### VS Code Configuration:
- `.vscode/launch.json` - Run & Debug configurations

### Android Configuration:
- `android/app/src/dev/AndroidManifest.xml` - Dev app name
- `android/app/src/prod/AndroidManifest.xml` - Prod app name
- `android/app/build.gradle.kts` - Flavor configuration
- `android/app/src/main/AndroidManifest.xml` - Added `tools:replace` for manifest merger

## Quick Test

1. **In VS Code:**
   - Open "Run and Debug" (Ctrl+Shift+D)
   - Select "Dev Flavor" from dropdown
   - Click play ▶️
   - Check app name shows "Movie App Dev"

2. **Run Prod:**
   - Select "Prod Flavor" from dropdown
   - Click play ▶️
   - Check app name shows "Movie App"

3. **Install both** and verify you can run them simultaneously on your device!

## Troubleshooting

**Error: "Manifest merger failed"**
- ✅ Fixed! Added `tools:replace="android:label"` to AndroidManifest.xml

**Can't see flavors in Run & Debug**
- ✅ Fixed! Created `.vscode/launch.json` with flavor configurations
- Reload VS Code if needed (Ctrl+Shift+P → "Reload Window")
