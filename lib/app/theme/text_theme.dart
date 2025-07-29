import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextTheme {
  static TextTheme lightTextTheme = const TextTheme(
    headlineLarge: TextStyle(
        fontFamily: 'Roboto', fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textLight),
    headlineMedium: TextStyle(
        fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight),
    bodyLarge: TextStyle(
        fontFamily: 'Roboto', fontSize: 16, color: AppColors.textLight),
    bodyMedium: TextStyle(
        fontFamily: 'Roboto', fontSize: 14, color: AppColors.textLight),
  );

  static TextTheme darkTextTheme = const TextTheme(
    headlineLarge: TextStyle(
        fontFamily: 'Roboto', fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textDark),
    headlineMedium: TextStyle(
        fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
    bodyLarge: TextStyle(
        fontFamily: 'Roboto', fontSize: 16, color: AppColors.textDark),
    bodyMedium: TextStyle(
        fontFamily: 'Roboto', fontSize: 14, color: AppColors.textDark),
  );
}
