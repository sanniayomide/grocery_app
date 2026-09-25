import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Gradient tokens. Kept separate from [AppColors] so gradients stay an
/// intentional, limited set rather than something every screen invents.
///
/// Usage rule (from the design brief): gradients mark ONE focal element per
/// screen — a hero banner, a primary CTA, an active nav icon, or a progress
/// indicator. Never apply to backgrounds or repeated list items.
class AppGradients {
  AppGradients._();

  /// Primary brand gradient — hero banners, primary buttons, active states.
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primaryLight, AppColors.primaryDark],
  );

  /// Warm accent gradient — promo badges and urgency-only elements.
  static const LinearGradient accent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.accentLight, AppColors.accent],
  );

  /// Soft background wash for image placeholders / hero image containers.
  static const LinearGradient softWash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primaryTint, AppColors.primaryTintStrong],
  );
}
