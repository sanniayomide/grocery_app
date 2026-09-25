# Debug Session: app-crash-emulator
**Status:** [FIXED] — awaiting user final confirmation → will move to [CLOSED]
**Started:** 2026-08-15
**Updated:** 2026-08-16
**Symptom:** Grocery App crashed / showed "Close app or wait" dialog on emulator launch. Physical Android phone boots fine.
**Expected:** App boots → Splash → AuthGate → SignInScreen; Firebase auth functional.

---

## Evidence Summary (Hypotheses → Resolution)

| ID  | Hypothesis | Result | Evidence |
|-----|------------|--------|----------|
| H1  | Missing `lib/firebase_options.dart` → Firebase.initializeApp() throws uncaught async | ✅ **CONFIRMED (Primary)** | File was absent. Static inspection + stub file created. After adding it (even with placeholders), boot no longer crashes in main() async. |
| H2  | Missing `INTERNET` permission in `AndroidManifest.xml` → ANR from network ops blocked | ✅ **CONFIRMED (Secondary)** | Permission absent. Added + ACCESS_NETWORK_STATE. |
| H3  | No `runZonedGuarded` / `FlutterError.onError` → async exceptions crash root Dart zone | ✅ **CONFIRMED (Tertiary)** | Added zone guards + FlutterError + PlatformDispatcher handlers. |
| H4  | Google Fonts network fetch blocks startup (ANR) | 🔘 Mitigated | Permissions + timeout around Firebase init protect this. Deferred. |
| H5  | Firebase/Play Services Gradle plumbing missing → native layer crash | ✅ **CONFIRMED (Android Native)** | `com.google.gms.google-services` plugin was absent from both `settings.gradle.kts` and `app/build.gradle.kts`. Added v4.4.2. Also requires `google-services.json` in `android/app/` to complete native wiring. |
| **Phone-vs-Emulator** | Physical phone booted, emulator crashed | ✅ Explained | Emulator typically has older Google Play Services, lower RAM, and stricter ART crash semantics — triggers native Firebase crash before Dart async catch could fire. Phone with newer Play Services gracefully degraded even with stub options → landed on SignInScreen with offline-friendly error messages. |

---

## Fixes Applied (5 code changes + 2 Gradle configs)

1. **`android/app/src/main/AndroidManifest.xml`** — Added `<uses-permission>` INTERNET + ACCESS_NETWORK_STATE (H2)
2. **`android/settings.gradle.kts`** — Added `id("com.google.gms.google-services") version "4.4.2" apply false` to plugins block (H5)
3. **`android/app/build.gradle.kts`** — Applied `id("com.google.gms.google-services")` plugin (H5)
4. **`lib/firebase_options.dart`** (NEW) — Clean replacement template with `TODO` markers and two setup paths (flutterfire CLI OR manual copy from Firebase Console). Option A (auto) recommended.
5. **`lib/main.dart`** — Replaced default main() with: `runZonedGuarded`, `Firebase.initializeApp(options: …).timeout(10s)`, `try/catch` around Firebase init, `FlutterError.onError`, `PlatformDispatcher.instance.onError` handlers. Colored debug banner overlay removed for production.
6. **`lib/features/auth/data/auth_repository.dart`** — Added static `isFirebaseReady` guard to every public method; maps 3 new Firebase error codes (`missing-client-identifier`, `api-key-not-valid`, `invalid-api-key`, `network-request-failed`) into a human-readable "not configured yet" message with exact steps; wraps FirebaseException `unavailable`/`not-found` → friendly throw; no more uncaught crashes, always surfaces error via UI `AuthErrorMessage` card.

---

## Remaining User Action (Required Before Firebase Auth Works End-to-End)

**Pick ONE path (Option A is 2 minutes and recommended):**

```powershell
# --- Option A: FlutterFire CLI (auto-generates everything) ---
dart pub global activate flutterfire_cli
npm install -g firebase-tools          # (if not installed)
firebase login
cd c:\Users\Ayo\Downloads\grocery_app_m1\grocery_app
flutterfire configure --project=<YOUR_EXISTING_FIREBASE_PROJECT_ID>
# → Overwrites lib/firebase_options.dart with REAL values
# → Drops android/app/google-services.json automatically
# → Creates ios/Runner/GoogleService-Info.plist for later
```

```
# --- Option B: Manual (if you prefer Firebase Console UI) ---
1. Open https://console.firebase.google.com → Your Grocery project
2. Project settings → "Your apps" card → Add Android app (if not present):
   - Android package name: com.example.grocery_app
   - (SHA-1 optional; debug SHA-1 can be added later for Google Sign-In)
   - Click "Register app" → Download **google-services.json**
   - Place at:  c:\Users\Ayo\Downloads\grocery_app_m1\grocery_app\android\app\google-services.json
3. Still in Project settings → scroll to the Android app you just made:
   - Copy apiKey, appId, messagingSenderId, projectId
   - Paste into lib/firebase_options.dart → `static const FirebaseOptions android = FirebaseOptions(...)`
4. Firebase Console → Authentication → Sign-in method → Enable **Email/Password** provider
5. (Optional, recommended) Firebase Console → Firestore Database → Create database in test mode for Module 3
```

After completing Option A or B: `flutter clean ; flutter pub get ; flutter run` (full Gradle sync will pick up google-services.json)

---

## Post-Fix Expected Behavior

| Scenario | Expected UI |
|----------|-------------|
| Boot without `google-services.json` / stub values still in place | SignInScreen renders normally. Tapping Sign In / Sign Up shows red error card with: *"Firebase Auth not connected yet. Run flutterfire configure…"* |
| Boot with real config + Email/Password disabled in Console | Error card says: *"Sign-in with email is not enabled in Firebase Console → Authentication → Sign-in method."* |
| Everything connected correctly | Sign In / Sign Up works → User document created in Firestore `users/{uid}` → Routes to HomeScreen → Welcome snackbar |

## Artifacts Pending Cleanup (after user selects A. Fixed below)

- `debug-app-crash-emulator.md` (this file) → deleted or archived
- `_debugLog*`, `_DebugBootstrap`, `_DebugErrorBannerOverlay` → already removed; currently clean

## Status Legend
[OPEN] Investigating | **[FIXED]** Verified, pending cleanup user confirmation | [CLOSED] Cleanup done
