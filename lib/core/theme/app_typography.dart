import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Shared text styles using Sora and Inter.

class AppTypography {
  AppTypography._();

  static TextStyle get _sora => GoogleFonts.sora();
  static TextStyle get _inter => GoogleFonts.inter();

  // Headings
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

  // Price labels
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
