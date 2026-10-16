# Android emulator startup troubleshooting

Historical notes on Firebase initialization and Android emulator startup failures.

## Checks

1. Run `flutter doctor -v` and verify the Android toolchain and emulator.
2. Ensure the Firebase Android application ID matches `android/app/build.gradle.kts`.
3. Regenerate platform configuration with `flutterfire configure --project=grocery-app-21838`.
4. Confirm `android/app/google-services.json` and `lib/firebase_options.dart` target the same project.
5. Run `flutter clean`, `flutter pub get`, and `flutter run`.
6. Review emulator logs and `flutter run -v` output if startup still fails.

## Common failure points

- Missing or mismatched Firebase configuration
- Android emulator system images or Google Play Services issues
- Cached Gradle/build artifacts
- Unavailable network services during sign-in

## Notes

The original emulator startup investigation predates the checkout and orders features. This document is reference material, not a record of current test results. Firebase initialization and sign-in should be verified on a clean emulator before release.
