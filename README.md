# Grocery App — Module 1: Project Setup & Design System

This is the design-system foundation for the Customer app (Admin and
Delivery will reuse `core/theme` and `core/widgets` unchanged).

## What's in here

```
lib/
  core/
    theme/
      app_colors.dart       -> every color in the app, one file
      app_gradients.dart    -> the two approved gradients, nothing else
      app_typography.dart   -> Sora (headings) + Inter (body) type scale
      app_dimensions.dart   -> spacing/radius/icon-size tokens (4pt grid)
      app_theme.dart         -> assembles the above into ThemeData
      theme.dart              -> barrel export
    widgets/
      app_icon.dart          -> typed wrapper around the custom SVG icons
assets/
  icons/
    ic_basket_sprout.svg     -> cart
    ic_route_pin.svg         -> delivery tracking
    ic_receipt_check.svg     -> orders/history
    ic_wallet_leaf.svg       -> payments
    ic_search_grain.svg      -> search
pubspec.yaml
```

## Why this structure

- **Feature-first, not layer-first.** `core/` holds cross-app things only
  (theme, shared widgets, shared services). Every screen-specific feature
  will get its own top-level folder under `lib/features/` (e.g.
  `lib/features/home/`, `lib/features/cart/`) — this keeps a debugging
  session scoped to one folder instead of hunting across `widgets/`,
  `models/`, `screens/` for one feature.
- **Tokens before widgets.** Nothing in the app should reference a raw hex
  code or a raw font size. If you find yourself typing `Color(0xFF...)` in
  a screen file, it belongs in `app_colors.dart` instead.
- **One barrel import.** `import 'core/theme/theme.dart'` gives every
  screen `AppColors`, `AppGradients`, `AppTypography`, `AppDimensions`,
  and `AppTheme` in one line.

## Setting this up locally (Windows)

1. Install Flutter SDK + Android Studio if you haven't (`flutter doctor`
   should show no blockers for Android).
2. Run `flutter create --org com.yourcompany grocery_app` in a fresh
   folder to get the full platform scaffolding (android/, ios/, etc. —
   I've only generated the Dart/asset layer here since this sandbox
   doesn't have the Flutter SDK or `pub.dev` access).
3. Copy the `lib/core/`, `assets/`, and `pubspec.yaml` contents from this
   package into that generated project (merge `pubspec.yaml` — keep the
   platform-specific bits Flutter generated, add the `dependencies` and
   `assets:` block from this file).
4. Run `flutter pub get`.
5. In `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'core/theme/theme.dart';

void main() => runApp(const GroceryApp());

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery App',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const Placeholder(), // Module 2 (Auth) replaces this
    );
  }
}
```

6. Using an icon anywhere in the app:

```dart
AppIcon(AppIconType.cart, isActive: true) // gradient-filled, active tab
AppIcon(AppIconType.search)               // flat muted color, default state
```

## Next: Module 2 — Authentication

Once you've confirmed this compiles cleanly on your machine, we'll set up
Firebase (Auth + Firestore + custom claims for role-based access across
Customer/Admin/Delivery) and build the sign-in/sign-up screens using these
same tokens.
