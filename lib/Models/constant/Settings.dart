class Settings {
  static const String darkModeString = "DARK_MODE_INDEX";
  static const String primaryColorString = "PRIMARY_COLOR_INDEX";
  static const String numChartsString = "NUM_CHARTS_TO_SHOW";
  static const String textSizeString = "TEXT_SIZE";

  late int darkModeIndex;
  late int primaryColorIndex;
  late int numChartsToShow;

  static const String smallFontSize = "SMALL";
  static const String mediumFontSize = "MEDIUM";
  static const String largeFontSize = "LARGE";

  static getCurrTextSize(String currTextStored) {
    if (currTextStored == largeFontSize) {
      return TextSize.LARGE;
    } else if (currTextStored == mediumFontSize) {
      return TextSize.MEDIUM;
    } else {
      return TextSize.SMALL;
    }
  }

  static getCurrTextString(TextSize currTextSize) {
    if (currTextSize == TextSize.LARGE) {
      return largeFontSize;
    } else if (currTextSize == TextSize.MEDIUM) {
      return mediumFontSize;
    } else {
      return smallFontSize;
    }
  }
}

enum TextSize {
  SMALL,
  MEDIUM,
  LARGE,
}
