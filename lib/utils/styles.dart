import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mock_bloc_stream/utils/color.dart';

class StylesConstant {
  static TextStyle kHeading5 =
      GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w400);

  static TextStyle kHeading6 = GoogleFonts.poppins(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );
  static TextStyle kSubtitle = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  );
  static TextStyle kBodyText = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  static TextTheme kTextTheme = TextTheme(
    headlineSmall: kHeading5,
    titleLarge: kHeading6,
    titleMedium: kSubtitle,
    bodyMedium: kBodyText,
  );

  static TextStyle ts16w400 =
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400);

  static TextStyle ts23w700 =
      GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w700);

  static TextStyle ts13w400 =
      GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400);

  static TextStyle ts13w700 =
      GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700);

  static TextStyle ts16w500cWhite = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ColorConstant.kWhite,
  );

  static TextStyle ts16w500 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle ts16w700 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
}
