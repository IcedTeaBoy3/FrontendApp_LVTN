import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './colors.dart';

class AppTheme {
  // LightTextTheme
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      color: Colors.black54,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black54,
    ),
    bodySmall: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black45,
    ),
    headlineMedium: GoogleFonts.roboto(
      color: AppColors.primaryBlue,
      fontWeight: FontWeight.bold,
    ),
  );
  // DarkTextTheme
  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: Colors.white70,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white54,
    ),
    bodySmall: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white38,
    ),
  );
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryBlue,
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.black87,
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryBlue,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      elevation: 4.0,
      type: BottomNavigationBarType.fixed,
      unselectedLabelStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    textTheme: lightTextTheme,
  );
  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.white70,
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryBlue,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black87,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: Colors.white70,
      selectedLabelStyle: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      elevation: 4.0,
      type: BottomNavigationBarType.fixed,
      unselectedLabelStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    textTheme: darkTextTheme,
  );
}
