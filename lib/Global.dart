import 'package:chore_app/Models/CircleData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import 'ColorControl/AppColors.dart';
import 'Models/constant/ThemeColors.dart';
import 'Providers/ThemeProvider.dart';

/// @nodoc
class Global {
  static bool isPhone = Device.get().isPhone;
  static bool isHighPixelRatio = (Device.devicePixelRatio > 2);
  static double toolbarHeight = (isPhone) ? 65.0 : 85.0;

  // Constants Decided by me that could change
  static const int TABS_ALLOWED = 3;

  // Make sure that this is defined before the chart is defined
  static ThemeColors currentTheme = AppColors.blueTheme;

  // These will be changed / checked by file
  static int currPrimaryColorIndex = 0;

  static ThemeProvider themeProvider = ThemeProvider();
  static CircleSettings circleSettings = CircleSettings();
  static RingCharLimits ringCharLimits = RingCharLimits();
  static Settings settings = Settings();
}

class Settings {
  static const String darkModeString = "DARK_MODE_INDEX";
  static const String primaryColorString = "PRIMARY_COLOR_INDEX";
  static const String numChartsString = "NUM_CHARTS_TO_SHOW";

  late int darkModeIndex;
  late int primaryColorIndex;
  late int numChartsToShow;
}

class RingCharLimits {
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
}

class CircleSettings {
  CircleSettings();

  final int overflowLineLimit = 2;
  final double chunkOverflowLimitProportion = 0.35;
  final double circleOneTextRadiusProportion = 0.6;
  final double spaceBetweenLines = 5;

  final List<double> circleOneRadiusProportions = [0.4, 0.6];
  final List<double> circleTwoRadiusProportions = [0.7, 1.0];
  final double circleThreeRadiusProportion = 1.0;

  final double circleOneFontSize = 8.0;
  final double circleTwoFontSize = 14.0;
  final double circleThreeFontSize = 14.0;
}
