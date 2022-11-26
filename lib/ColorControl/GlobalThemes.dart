import 'dart:ffi';

import 'package:chore_app/ColorControl/AppColors.dart';
import 'package:flutter/material.dart';
import '../Global.dart';

class GlobalThemes {
  //Themes to add

  static ThemeData getThemeData(int isDarkMode) {
    return ThemeData(
      brightness: getBrightness(isDarkMode),
      primarySwatch: AppColors.getPrimaryColorSwatch(),
      primaryColor: getPrimaryColorForTheme(isDarkMode),
      textTheme: getTextTheme(isDarkMode),
      elevatedButtonTheme: getEvevatedButtonThemeData(isDarkMode),
      progressIndicatorTheme: getProgressIndicatorThemeData(isDarkMode),
      floatingActionButtonTheme: getFABThemeData(isDarkMode),
      iconTheme: getIconThemeData(isDarkMode),
      secondaryHeaderColor: getSecondaryColor(isDarkMode),
      listTileTheme: getListTileThemeData(isDarkMode),
    );
  }

  static ListTileThemeData getListTileThemeData(int isDarkMode) {
    if (isDarkMode == 0) {
      return const ListTileThemeData(
        textColor: Colors.black,
      );
    } else {
      return const ListTileThemeData(
        textColor: Colors.white,
      );
    }
  }

  //Text Theme has all the smaller text styles inside it
  static TextTheme getTextTheme(int isDarkMode) {
    return TextTheme(
      displaySmall: getDisplaySmall(isDarkMode),
      displayMedium: getDisplayMedium(isDarkMode),
      displayLarge: getDisplayLarge(isDarkMode),
      headlineLarge: getTextStyleHeaderLarge(isDarkMode),
      headlineMedium: getTextStyleHeaderMedium(isDarkMode),
      headlineSmall: getTextStyleHeaderSmall(isDarkMode),
    );
  }

  static IconThemeData getIconThemeData(int isDarkMode) {
    if (isDarkMode == 0) {
      return IconThemeData(
        color: Colors.black,
        opacity: 70,
        size: (Global.isPhone) ? 24 : 32,
      );
    } else {
      return IconThemeData(
        color: Colors.white,
        opacity: 70,
        size: (Global.isPhone) ? 24 : 32,
      );
    }
  }

  static FloatingActionButtonThemeData getFABThemeData(int isDarkMode) {
    if (isDarkMode == 0) {
      return FloatingActionButtonThemeData(
        backgroundColor: AppColors.getPrimaryColorSwatch().shade500,
        //foregroundColor:
      );
    } else {
      return FloatingActionButtonThemeData(
        backgroundColor: AppColors.getPrimaryColorSwatch().shade600,
        //foregroundColor:
      );
    }
  }

  static TextStyle getDisplaySmall(int isDarkMode) {
    if (isDarkMode == 0) {
      return TextStyle(
        fontSize: (Global.isPhone) ? 14 : 24,
        color: Colors.black,
      );
    } else {
      return TextStyle(
        fontSize: (Global.isPhone) ? 14 : 24,
        color: Colors.white,
      );
    }
  }

  static TextStyle getDisplayMedium(int isDarkMode) {
    if (isDarkMode == 0) {
      return TextStyle(
        fontSize: (Global.isPhone) ? 18 : 32,
        color: Colors.black,
      );
    } else {
      return TextStyle(
        fontSize: (Global.isPhone) ? 18 : 32,
        color: Colors.white,
      );
    }
  }

  static TextStyle getDisplayLarge(int isDarkMode) {
    if (isDarkMode == 0) {
      return TextStyle(
        fontSize: (Global.isPhone) ? 18 : 32,
        color: Colors.black,
      );
    } else {
      return TextStyle(
        fontSize: (Global.isPhone) ? 18 : 32,
        color: Colors.white,
      );
    }
  }

  static TextStyle getTextStyleHeaderLarge(int isDarkMode) {
    if (isDarkMode == 0) {
      return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (Global.isPhone) ? 22 : 36,
        color: Colors.black,
      );
    } else {
      return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (Global.isPhone) ? 22 : 36,
        color: Colors.white,
      );
    }
  }

  static TextStyle getTextStyleHeaderMedium(int isDarkMode) {
    if (isDarkMode == 0) {
      return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (Global.isPhone) ? 18 : 24,
        color: Colors.black,
      );
    } else {
      return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (Global.isPhone) ? 18 : 24,
        color: Colors.white,
      );
    }
  }

  static TextStyle getTextStyleHeaderSmall(int isDarkMode) {
    if (isDarkMode == 0) {
      return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (Global.isPhone) ? 12 : 18,
        color: Colors.black,
      );
    } else {
      return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (Global.isPhone) ? 12 : 18,
        color: Colors.white,
      );
    }
  }

  static ProgressIndicatorThemeData getProgressIndicatorThemeData(
      int isDarkMode) {
    if (isDarkMode == 0) {
      return ProgressIndicatorThemeData(
        color: AppColors.getPrimaryColorSwatch().shade700,
        circularTrackColor: Colors.white,
      );
    } else {
      return ProgressIndicatorThemeData(
        color: AppColors.getPrimaryColorSwatch().shade300,
        circularTrackColor: AppColors.getPrimaryColorSwatch().shade900,
      );
    }
  }

  static ElevatedButtonThemeData getEvevatedButtonThemeData(int isDarkMode) {
    if (isDarkMode == 0) {
      return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.getPrimaryColorSwatch().shade400,
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: (Global.isPhone) ? 14 : 24,
          ),
          foregroundColor: Colors.black,
        ),
      );
    } else {
      return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.getPrimaryColorSwatch().shade600,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: (Global.isPhone) ? 14 : 24,
          ),
          foregroundColor: Colors.white,
        ),
      );
    }
  }

  static Color getPrimaryColorForTheme(int isDarkMode) {
    if (isDarkMode == 0) {
      return AppColors.getPrimaryColorSwatch().shade500;
    } else {
      return AppColors.getPrimaryColorSwatch().shade400;
    }
  }

  static Color getSecondaryColor(int isDarkMode) {
    if (isDarkMode == 0) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  static Brightness getBrightness(int isDarkMode) {
    if (isDarkMode == 0) {
      return Brightness.light;
    } else {
      return Brightness.dark;
    }
  }
}
