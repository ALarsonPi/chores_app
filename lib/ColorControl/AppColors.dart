import 'package:flutter/material.dart';

import '../Global.dart';
import '../Models/ThemeColors.dart';

class AppColors {
  static MaterialColor getPrimaryColorSwatch() {
    return AppColors.getMaterialColorFromColor(
      Global.themeProvider.selectedPrimaryColor,
    );
  }

  static ThemeColors blueTheme = ThemeColors(
    primaryColor: Colors.lightBlue[100] as Color,
    secondaryColor: Colors.lightBlue[500] as Color,
    tertiaryColor: Colors.lightBlue[700] as Color,
    primaryTextColor: Colors.black,
    secondaryTextColor: Colors.black,
    tertiaryTextColor: Colors.black,
    lineColors: const [Colors.blue, Colors.white, Colors.white],
  );
  static ThemeColors redTheme = ThemeColors(
    primaryColor: Colors.red[200] as Color,
    secondaryColor: Colors.red[400] as Color,
    tertiaryColor: Colors.red[700] as Color,
    primaryTextColor: Colors.black,
    secondaryTextColor: Colors.black,
    tertiaryTextColor: Colors.black,
    lineColors: const [Colors.white, Colors.white, Colors.white],
  );
  static ThemeColors purpleTheme = ThemeColors(
    primaryColor: Colors.purple[100] as Color,
    secondaryColor: Colors.purple[300] as Color,
    tertiaryColor: Colors.purple[400] as Color,
    primaryTextColor: Colors.black,
    secondaryTextColor: Colors.black,
    tertiaryTextColor: Colors.black,
    lineColors: const [Colors.white, Colors.white, Colors.white],
  );
  static ThemeColors greenTheme = ThemeColors(
    primaryColor: Colors.green[200] as Color,
    secondaryColor: Colors.green[500] as Color,
    tertiaryColor: Colors.green[700] as Color,
    primaryTextColor: Colors.black,
    secondaryTextColor: Colors.black,
    tertiaryTextColor: Colors.black,
    lineColors: const [Colors.white, Colors.white, Colors.white],
  );
  static ThemeColors orangeTheme = ThemeColors(
    primaryColor: Colors.orange[200] as Color,
    secondaryColor: Colors.orange[500] as Color,
    tertiaryColor: Colors.orange[700] as Color,
    primaryTextColor: Colors.black,
    secondaryTextColor: Colors.black,
    tertiaryTextColor: Colors.black,
    lineColors: const [Colors.white, Colors.white, Colors.white],
  );

  static List<Color> primaryColorList = [
    const Color(0xff16b9fd),
    const Color(0xffd23156),
    const Color(0xffb73d99),
    const Color.fromARGB(255, 27, 200, 99),
    const Color(0xffe5672f),
  ];

  static List<ThemeColors> themeColorList = [
    blueTheme,
    redTheme,
    purpleTheme,
    greenTheme,
    orangeTheme,
  ];

  static Color getShade(Color color, {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness(
        (darker ? (hsl.lightness - value) : (hsl.lightness + value))
            .clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static MaterialColor getMaterialColorFromColor(Color color) {
    Map<int, Color> _colorShades = {
      50: getShade(color, value: 0.5),
      100: getShade(color, value: 0.4),
      200: getShade(color, value: 0.3),
      300: getShade(color, value: 0.2),
      400: getShade(color, value: 0.1),
      500: color,
      600: getShade(color, value: 0.1, darker: true),
      700: getShade(color, value: 0.15, darker: true),
      800: getShade(color, value: 0.2, darker: true),
      900: getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.value, _colorShades);
  }
}
