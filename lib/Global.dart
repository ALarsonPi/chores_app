import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

/// @nodoc
class Global {
  static bool isPhone = Device.get().isPhone;
  static bool isHighPixelRatio = (Device.devicePixelRatio > 2);
  static double toolbarHeight = (isPhone) ? 65.0 : 85.0;

  static RingCharLimit twoItemLimit =
      RingCharLimit(numItems: 2, secondRingLimit: 35, thirdRingLimit: 45);
  static RingCharLimit threeItemLimit =
      RingCharLimit(numItems: 3, secondRingLimit: 30, thirdRingLimit: 40);
  static RingCharLimit fourItemLimit =
      RingCharLimit(numItems: 4, secondRingLimit: 25, thirdRingLimit: 35);
  static RingCharLimit fiveItemLimit =
      RingCharLimit(numItems: 5, secondRingLimit: 20, thirdRingLimit: 30);
  static RingCharLimit sixItemLimit =
      RingCharLimit(numItems: 6, secondRingLimit: 15, thirdRingLimit: 25);
  static RingCharLimit sevenItemLimit =
      RingCharLimit(numItems: 7, secondRingLimit: 12, thirdRingLimit: 20);
  static RingCharLimit eightItemLimit =
      RingCharLimit(numItems: 8, secondRingLimit: 12, thirdRingLimit: 20);

  // Make sure that this is defined before the chart is defined
  static ThemeColors currentTheme = blueTheme;

  static ThemeColors blueTheme = ThemeColors(
    primaryColor: Colors.lightBlue[100] as Color,
    secondaryColor: Colors.lightBlue[500] as Color,
    tertiaryColor: Colors.lightBlue[700] as Color,
  );
  static ThemeColors redTheme = ThemeColors(
    primaryColor: Colors.red[200] as Color,
    secondaryColor: Colors.red[400] as Color,
    tertiaryColor: Colors.red[700] as Color,
  );
  static ThemeColors purpleTheme = ThemeColors(
    primaryColor: Colors.purple[100] as Color,
    secondaryColor: Colors.purple[300] as Color,
    tertiaryColor: Colors.purple[400] as Color,
  );
  static ThemeColors greenTheme = ThemeColors(
    primaryColor: Colors.green[200] as Color,
    secondaryColor: Colors.green[500] as Color,
    tertiaryColor: Colors.green[700] as Color,
  );
  static ThemeColors orangeTheme = ThemeColors(
    primaryColor: Colors.orange[200] as Color,
    secondaryColor: Colors.orange[500] as Color,
    tertiaryColor: Colors.orange[700] as Color,
  );
}

class ThemeColors {
  ThemeColors(
      {required this.primaryColor,
      required this.secondaryColor,
      required this.tertiaryColor});
  Color primaryColor;
  Color secondaryColor;
  Color tertiaryColor;
}

class RingCharLimit {
  RingCharLimit({
    required this.numItems,
    required this.secondRingLimit,
    required this.thirdRingLimit,
  });

  int numItems;
  int secondRingLimit;
  int thirdRingLimit;
}
