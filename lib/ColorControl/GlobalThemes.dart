import 'package:chore_app/ColorControl/AppColors.dart';
import 'package:chore_app/Widgets/UserLoginLogout/UI_Helpers.dart';
import 'package:flutter/material.dart';
import '../Global.dart';

class GlobalThemes {
  //Themes to add

  static ThemeData getThemeData(bool isDarkMode, BuildContext context) {
    isDarkMode = !isDarkMode;
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
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 1,
            color: Color.fromARGB(255, 231, 231, 231),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 1,
            color: loginPrimaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
      ),
    );
  }

  static ListTileThemeData getListTileThemeData(bool isDarkMode) {
    if (isDarkMode) {
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
  static TextTheme getTextTheme(bool isDarkMode) {
    return TextTheme(
      displaySmall: getDisplaySmall(isDarkMode),
      displayMedium: getDisplayMedium(isDarkMode),
      displayLarge: getDisplayLarge(isDarkMode),
      headlineLarge: getTextStyleHeaderLarge(isDarkMode),
      headlineMedium: getTextStyleHeaderMedium(isDarkMode),
      headlineSmall: getTextStyleHeaderSmall(isDarkMode),
    );
  }

  static IconThemeData getIconThemeData(bool isDarkMode) {
    if (isDarkMode) {
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

  static FloatingActionButtonThemeData getFABThemeData(bool isDarkMode) {
    if (isDarkMode) {
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

  static TextStyle getDisplaySmall(bool isDarkMode) {
    if (isDarkMode) {
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

  static TextStyle getDisplayMedium(bool isDarkMode) {
    if (isDarkMode) {
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

  static TextStyle getDisplayLarge(bool isDarkMode) {
    if (isDarkMode) {
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

  static TextStyle getTextStyleHeaderLarge(bool isDarkMode) {
    if (isDarkMode) {
      return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (Global.isPhone) ? 20 : 30,
        color: Colors.black,
      );
    } else {
      return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (Global.isPhone) ? 20 : 30,
        color: Colors.white,
      );
    }
  }

  static TextStyle getTextStyleHeaderMedium(bool isDarkMode) {
    if (isDarkMode) {
      return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (Global.isPhone) ? 16 : 22,
        // NOTICE - Change from previous apps
        color: const Color.fromARGB(255, 250, 253, 255),
      );
    } else {
      return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (Global.isPhone) ? 18 : 24,
        color: Colors.white,
      );
    }
  }

  static TextStyle getTextStyleHeaderSmall(bool isDarkMode) {
    if (isDarkMode) {
      return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (Global.isPhone) ? 12 : 18,
        color: Colors.white,
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
      bool isDarkMode) {
    if (isDarkMode) {
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

  static ElevatedButtonThemeData getEvevatedButtonThemeData(bool isDarkMode) {
    if (isDarkMode) {
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

  static Color getPrimaryColorForTheme(bool isDarkMode) {
    if (isDarkMode) {
      return AppColors.getPrimaryColorSwatch().shade500;
    } else {
      return AppColors.getPrimaryColorSwatch().shade400;
    }
  }

  static Color getSecondaryColor(bool isDarkMode) {
    if (isDarkMode) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  static Brightness getBrightness(bool isDarkMode) {
    if (isDarkMode) {
      return Brightness.light;
    } else {
      return Brightness.dark;
    }
  }
}
