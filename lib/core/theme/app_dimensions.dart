/// Spacing and radius tokens. Using named constants instead of raw numbers
/// in widgets makes layout bugs ("why is this card 2px off") much faster
/// to trace — grep AppDimensions instead of hunting for stray EdgeInsets.
class AppDimensions {
  AppDimensions._();

  // Spacing (4pt grid)
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 24;
  static const double spaceXxl = 32;

  // Radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 20;
  static const double radiusPill = 999;

  // Icon sizes
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 28;
}
