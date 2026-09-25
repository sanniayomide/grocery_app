import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_icon.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppDimensions.spaceXxl),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: AppGradients.primary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
          child: const Center(
            child: AppIcon(
              AppIconType.cart,
              size: AppDimensions.iconLg,
              isActive: true,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXl),
        Text(title, style: AppTypography.h1),
        const SizedBox(height: AppDimensions.spaceSm),
        Text(
          subtitle,
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spaceXxl),
      ],
    );
  }
}
