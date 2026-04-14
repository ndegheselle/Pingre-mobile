# Development

Start an emulator, `Ctrl+Shift+P` :
```
>flutter: launch emulator
```

Generate the localizations files :
``` Bash
flutter run
```

Generate the Drift tables :
```
dart run build_runner build
dart run build_runner watch
```

# Build

## APK

The key file must be in `D:\Projets\Pingre\android\upload-keystore.jks`.

Clean cache :
```
flutter clean
flutter pub get
```

Splitted by abi :
```
flutter build apk --split-per-abi
```

Install with adb to keep the app data :
```
adb install -r build\app\outputs\flutter-apk\app-arm64-v8a-release.apk
```

## Install with flutter

```
flutter build apk --release
```

```
flutter install --release
```

# Inspiration

https://www.macstories.net/reviews/nudget-review-budgeting-made-simple/
https://www.nudgetapp.com/