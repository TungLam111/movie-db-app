import 'package:flutter/material.dart';

class ColorConstant {
  static const Color kRichBlack = Color(0xFF1E1E29);
  static const Color kSpaceGrey = Color(0xFF26262F);
  static const Color kOxfordBlue = Color(0xFF001D3D);
  static const Color kGrey850 = Color(0xFF303030);
  static const Color kGrey800 = Color(0xFF424242);
  static const Color kFF5E656F = Color(0xFF5E656F);
  static const Color kWhite = Color(0xFFFFFFFF);
  static const Color kFF21252B = Color(0xFF21252B);
  static const Color kFF0071DF = Color(0xFF0071DF);
  static const Color kFF9CA5B4 = Color(0xFF9CA5B4);
  static const Color kFFFF7A59 = Color(0xFFFF7A59);
  static const Color kFF03A87C = Color(0xFF03A87C);
  static const Color kFF363636 = Color(0xFF363636);
  static const Color kFF858585 = Color(0xFF858585);
  static const Color kFF5D5FEF = Color(0xFF5D5FEF);
  static const Color kFF181A1F = Color(0xFF181A1F);

  static const ColorScheme kColorScheme = ColorScheme(
    primary: Colors.redAccent,
    primaryContainer: Colors.redAccent,
    secondary: kSpaceGrey,
    secondaryContainer: kSpaceGrey,
    surface: kRichBlack,
    background: kRichBlack,
    error: Colors.redAccent,
    onPrimary: kRichBlack,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  );
}
