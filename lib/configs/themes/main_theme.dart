import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guest_allow/configs/themes/main_color.dart';

final ThemeData mainTheme = ThemeData(
  primaryColor: MainColor.primary,
  brightness: Brightness.light,
  scaffoldBackgroundColor: MainColor.backgroundColor,
  colorScheme: ColorScheme.fromSwatch(
    accentColor: MainColor.primary,
    cardColor: MainColor.white,
    errorColor: MainColor.danger,
  ),
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: MainColor.black,
    displayColor: MainColor.black,
  ),
  iconTheme: IconThemeData(
    color: MainColor.primary,
    size: 24.sp,
  ),
  indicatorColor: MainColor.primary,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.transparent,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 12.h,
    ),
    hintStyle: GoogleFonts.plusJakartaSans(
      color: MainColor.blackTextColor,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
    ),
    floatingLabelStyle: GoogleFonts.plusJakartaSans(
      color: MainColor.blackTextColor,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
    ),
    helperStyle: GoogleFonts.plusJakartaSans(
      color: MainColor.blackTextColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
    ),
  ),
);
