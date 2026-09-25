import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Type scale for the app suite.
///
/// Pairing: Sora (headings — geometric, a little personality) + Inter
/// (body/UI — chosen for legibility at small sizes like prices and
/// timestamps on dense product grids). See design brief for rationale.
///
/// Use these instead of raw TextStyle() calls so a font-size audit is a
/// one-file job, not a find-and-replace across 40 screens.
class AppTypography {
  AppTypography._();

  static TextStyle get _sora => GoogleFonts.sora();
  static TextStyle get _inter => GoogleFonts.inter();

  // Headings (Sora, weight 500 — never go heavier, it fights the brand voice)
  static TextStyle get h1 => _sora.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get h2 => _sora.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get h3 => _sora.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  // Body / UI (Inter)
  static TextStyle get bodyLarge => _inter.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => _inter.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  static TextStyle get bodySmall => _inter.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  // Prices — always Inter 500, always primaryDark, per design brief
  static TextStyle get price => _inter.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryDark,
      );

  static TextStyle get priceLarge => _inter.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryDark,
      );

  // Buttons
  static TextStyle get button => _inter.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textOnPrimary,
      );

  // Status badges
  static TextStyle get badge => _inter.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      );
}
