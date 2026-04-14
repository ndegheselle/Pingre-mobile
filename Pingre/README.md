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

```
flutter build apk --split-per-abi
```

# Inspiration

https://www.macstories.net/reviews/nudget-review-budgeting-made-simple/
https://www.nudgetapp.com/