import 'dart:async';
import 'dart:collection';

import 'package:chore_app/Models/constant/Settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:get_it/get_it.dart';

import 'ColorControl/AppColors.dart';
import 'Models/constant/CircleSettings.dart';
import 'Models/constant/RingCharLimit.dart';
import 'Models/constant/ThemeColors.dart';
import 'Models/frozen/Chart.dart';
import 'Providers/ThemeProvider.dart';
import 'Widgets/ChartDisplay/ChangeChart/ChangeTitle.dart';

/// @nodoc
class Global {
  static bool isPhone = Device.get().isPhone;
  static bool isHighPixelRatio = (Device.devicePixelRatio > 2);
  static double toolbarHeight = (isPhone) ? 65.0 : 85.0;
  static final getIt = GetIt.instance;

  // ignore: constant_identifier_names
  static const int NUM_CHARTS = 1;

  static void setupGetIt() {}

  static void makeSnackbar(String message) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static String currUserID = "ID";

  // Constants Decided by me that could change
  static const int TABS_ALLOWED = 3;

  // Make sure that this is defined before the chart is defined
  static ThemeColors currentTheme = AppColors.blueTheme;

// Making this global
  static Map<int, StreamSubscription> streamMap = HashMap();

  static int currPrimaryColorIndex = 0;

  static FocusNode titleFocusNode = FocusNode();
  static GlobalKey<ChangeTitleWidgetState> changeTitleWidgetKey =
      GlobalKey<ChangeTitleWidgetState>();
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  static bool dataTransferComplete = false;
  static List<Chart> chartHolderGlobal = List.empty(growable: true);

  // Transfer Variable
  static late TextSize currTextSize; //= TextSize.SMALL;
  static setCurrTextSize(TextSize size) {
    currTextSize = size;
  }

  static bool didUpdate = false;
  static getCurrTextSize() {
    return currTextSize;
  }

  static ThemeProvider themeProvider = ThemeProvider();
  static CircleSettings circleSettings = CircleSettings();
  static RingCharLimits ringCharLimits = RingCharLimits();
  static Settings settings = Settings();
  static GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
}

class EditedChart {
  EditedChart(this.editedChart, this.index);
  Chart editedChart;
  int index;
}
