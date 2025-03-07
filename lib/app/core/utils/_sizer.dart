import 'package:flutter/material.dart';

class Sizer {
  static const double Mobile = 300;
  static const double Tablet = 600;
  static const double Desktop = 1280;

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getDynamicWidth(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return width >= Desktop
        ? Desktop
        : width <= Desktop && width >= Tablet
            ? Tablet
            : Mobile;
  }

  static Screen getScreen(context) {
    final double width = MediaQuery.of(context).size.width;
    return width >= Desktop
        ? Screen.Desktop
        : width <= Desktop && width >= Tablet
            ? Screen.Tablet
            : Screen.Mobile;
  }

  static double mobileRegularFontSize = 14;

  static double tabletRegularFontSize = 16;

  static double desktopRegularFontSize = 16;
}

enum Screen { Desktop, Tablet, Mobile }
