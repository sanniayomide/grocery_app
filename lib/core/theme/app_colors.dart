import 'package:flutter/material.dart';

/// Centralized color tokens for the entire app suite (Customer, Admin,
/// Delivery). Never hardcode a hex value in a widget — add it here first.
///
/// Naming convention: `role` + `variant`, e.g. [primary], [primaryDark].
/// This keeps theming greppable when we need to retheme or debug contrast
/// issues later.
class AppColors {
  AppColors._();

  // --- Brand: lilac family ---
  static const Color primary = Color(0xFF9B7EDE); // buttons, active states
  static const Color primaryLight = Color(0xFFB497D6); // gradient start
  static const Color primaryDark = Color(0xFF6C4AB6); // gradient end
  static const Color primaryDeep = Color(0xFF5B3E8C); // admin app dominant

  static const Color primaryTint = Color(0xFFEEEDFE); // chips, light fills
  static const Color primaryTintStrong = Color(0xFFD8D2F3);

  // --- Accent: warm coral (urgency / promo only, never decorative) ---
  static const Color accent = Color(0xFFFF8A65);
  static const Color accentLight = Color(0xFFFFB199);
  static const Color accentDark = Color(0xFF712B13);

  // --- Semantic (status badges — must stay distinct from brand lilac) ---
  static const Color statusNew = Color(0xFFF0997B); // coral tint
  static const Color statusNewText = Color(0xFF4A1B0C);
  static const Color statusPreparing = Color(0xFFFAC775); // amber tint
  static const Color statusPreparingText = Color(0xFF412402);
  static const Color statusOutForDelivery = Color(0xFF9FE1CB); // teal tint
  static const Color statusOutForDeliveryText = Color(0xFF04342C);
  static const Color statusDelivered = Color(0xFF97C459); // green tint
  static const Color statusDeliveredText = Color(0xFF173404);
  static const Color statusCancelled = Color(0xFFF09595); // red tint
  static const Color statusCancelledText = Color(0xFF501313);

  // --- Neutrals ---
  static const Color background = Color(0xFFFAF9FC); // warm off-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE4E1EE);
  static const Color divider = Color(0xFFD3D1C7);

  static const Color textPrimary = Color(0xFF2C2C2A);
  static const Color textSecondary = Color(0xFF5F5E5A);
  static const Color textMuted = Color(0xFF888780);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // --- Feedback ---
  static const Color success = Color(0xFF3B6D11);
  static const Color error = Color(0xFFA32D2D);
  static const Color warning = Color(0xFF854F0B);
}
