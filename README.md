# CoffeeGuard Mobile

A Flutter client for the CoffeeGuard API: take or pick a photo
of a coffee leaf, send it to the backend, and see the diagnosed disease,
confidence score, and a care recommendation.

## Requirements

- Flutter SDK **3.24+** (Dart **3.4+**)
- Android Studio / Xcode for device emulators (or a physical phone with USB debugging)

Package versions are in `pubspec.yaml`

## Setup

Clone (or create) the project folder:

```bash
git clone https://github.com/Misiker101/coffeeguard-mobile.git
```


```bash
flutter pub get
```

### Add camera/gallery permissions

**Android** — add to `android/app/src/main/AndroidManifest.xml`, inside `<manifest>`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

**iOS** — add to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>CoffeeGuard needs camera access to photograph coffee leaves.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>CoffeeGuard needs photo library access to select leaf photos.</string>
```

## Run

```bash
flutter run
```

## Build a release APK (free, no Play Store account needed to test)

```bash
flutter build apk --release
```
The APK lands at `build/app/outputs/flutter-apk/app-release.apk`

## How it connects to the backend

`lib/services/coffeeguard_api.dart` posts the image as multipart form data to
your existing `POST /predict` endpoint; the
FastAPI app already returns `predicted_class`, `confidence`, and (after the
latest update) a `care_tip` string that the result screen displays directly.

## Project structure
```
coffeeguard_mobile/
├── lib/
│   ├── main.dart
│   ├── theme/app_theme.dart        # colors, typography
│   ├── services/coffeeguard_api.dart   # HTTP client for the FastAPI backend
│   └── screens/
│       ├── home_screen.dart        # capture/pick photo
│       └── result_screen.dart      # diagnosis + confidence + care tip
└── pubspec.yaml
```
