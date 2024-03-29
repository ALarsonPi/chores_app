import 'package:flutter/material.dart';

// Horizontal Spacing
const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
const Widget horizontalSpaceRegular = SizedBox(width: 18.0);
const Widget horizontalSpaceMedium = SizedBox(width: 25.0);
const Widget horizontalSpaceLarge = SizedBox(width: 50.0);

// Vertical Spacing
const Widget verticalSpaceTiny = SizedBox(height: 5.0);
const Widget verticalSpaceSmall = SizedBox(height: 10.0);
const Widget verticalSpaceRegular = SizedBox(height: 18.0);
const Widget verticalSpaceMedium = SizedBox(height: 25);
const Widget verticalSpaceLarge = SizedBox(height: 50.0);
const Widget verticalSpaceMassive = SizedBox(height: 120.0);

// colors
const Color loginPrimaryColor = Color(0xff22A45D);
const Color forgotPasswordPrimaryColor = Color(0xff09A7FD);
const Color loginMediumGreyColor = Color(0xff868686);
const Color loginDarkGreyColor = Color.fromARGB(255, 113, 112, 112);
// Text Style

/// The style used for all body text in the app
const TextStyle loginMediumGreyBodyTextStyle = TextStyle(
  color: loginMediumGreyColor,
  fontSize: kBodyTextSize,
);
const TextStyle loginDarkGreyBodyTextStyle = TextStyle(
  color: loginDarkGreyColor,
  fontSize: kBodyTextSize,
);

// Font Sizing
const double kBodyTextSize = 16;

// Screen Size Helpers
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

/// Returns the pixel amount for the percentage of the screen height. [percentage] should
/// be between 0 and 1 where 0 is 0% and 100 is 100% of the screens height
double screenHeightPercentage(BuildContext context, {double percentage = 1}) =>
    screenHeight(context) * percentage;

/// Returns the pixel amount for the percentage of the screen width. [percentage] should
/// be between 0 and 1 where 0 is 0% and 100 is 100% of the screens width
double screenWidthPercentage(BuildContext context, {double percentage = 1}) =>
    screenWidth(context) * percentage;
