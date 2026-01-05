import 'package:TourEase/core/app_bar_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    // useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,

    // textTheme: TTextTheme.lightTextTheme,
    // chipTheme: TChipTheme.lightChipTheme,
    // ignore: deprecated_member_use
    colorScheme: ColorScheme.light(background: Colors.white),
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    // checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    // bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    // outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    // inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    // elevatedButtonTheme: TElevatedButtonThem.lightElevatedButtonThem,
  );
  static ThemeData darkTheme = ThemeData(
    //useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    // textTheme: TTextTheme.darkTextTheme,
    // chipTheme: TChipTheme.lightChipTheme,
    // ignore: deprecated_member_use
    colorScheme: ColorScheme.dark(background: Colors.black),
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    // checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    // bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    // outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    // inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
    // elevatedButtonTheme: TElevatedButtonThem.darkElevatedButtonThem,
  );
}
