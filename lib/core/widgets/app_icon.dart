import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';

/// Available icon assets.

enum AppIconType {
  cart('assets/icons/ic_basket_sprout.svg'),
  delivery('assets/icons/ic_route_pin.svg'),
  orders('assets/icons/ic_receipt_check.svg'),
  wallet('assets/icons/ic_wallet_leaf.svg'),
  search('assets/icons/ic_search_grain.svg');

  final String assetPath;
  const AppIconType(this.assetPath);
}

/// SVG icon with an optional active-state gradient.

class AppIcon extends StatelessWidget {
  final AppIconType type;
  final double size;
  final bool isActive;
  final Color? color;

  const AppIcon(
    this.type, {
    super.key,
    this.size = 20,
    this.isActive = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final svg = SvgPicture.asset(
      type.assetPath,
      width: size,
      height: size,
      colorFilter: isActive
          ? null
          : ColorFilter.mode(
              color ?? AppColors.textMuted,
              BlendMode.srcIn,
            ),
    );

    if (!isActive) return svg;

    // Apply the active-state gradient.
    return ShaderMask(
      shaderCallback: (bounds) => AppGradients.primary.createShader(bounds),
      child: svg,
    );
  }
}
