import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class AuthFooterLink extends StatelessWidget {
  final String questionText;
  final String actionText;
  final VoidCallback? onTap;

  const AuthFooterLink({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(questionText, style: AppTypography.bodyMedium),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceXs,
              vertical: AppDimensions.spaceSm,
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionText,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class AuthErrorMessage extends StatelessWidget {
  final String? message;

  const AuthErrorMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: AppDimensions.iconMd,
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          Expanded(
            child: Text(
              message!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 0.5,
            color: AppColors.border,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMd,
          ),
          child: Text(
            'or',
            style: AppTypography.bodySmall,
          ),
        ),
        Expanded(
          child: Container(
            height: 0.5,
            color: AppColors.border,
          ),
        ),
      ],
    );
  }
}

class AuthSocialButton extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const AuthSocialButton({
    super.key,
    required this.assetPath,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.surface,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
        icon: Image.asset(
          assetPath,
          height: 22,
          width: 22,
          errorBuilder: (_, __, ___) => const Icon(Icons.person_outline),
        ),
        label: Text(
          label,
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
