import 'dart:ui';

class ThemeColors {
  ThemeColors({
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.tertiaryTextColor,
    required this.lineColors,
  });
  Color primaryColor;
  Color secondaryColor;
  Color tertiaryColor;

  Color primaryTextColor;
  Color secondaryTextColor;
  Color tertiaryTextColor;

  List<Color> lineColors;
}
