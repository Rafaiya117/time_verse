import 'package:flutter/material.dart';
import 'package:time_verse/core/utils/colors.dart';

// --- Light Theme Definition ---
// final ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,
//   scaffoldBackgroundColor: Colors.transparent, 
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: Colors.blue,
//     brightness: Brightness.light,
//   ).copyWith(
//     onSurface: Colors.black, 
//   ),
//   appBarTheme: const AppBarTheme(
//     backgroundColor: Color(0xFF051123),
//     foregroundColor: Colors.white,
//   ),
//   textTheme: const TextTheme(
//     bodyMedium: TextStyle(color: Colors.black),
//     headlineMedium: TextStyle(color: Colors.black),
//   ),
//   iconTheme: const IconThemeData(color: Colors.black87),
// );

// // --- Dark Theme Definition ---
// final ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   scaffoldBackgroundColor: Colors.transparent, 
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: Colors.deepPurple,
//     brightness: Brightness.dark,
//   ).copyWith(
//     onSurface: Colors.white, 
//   ),
  
//   appBarTheme: const AppBarTheme(
//     backgroundColor: Colors.deepPurple,
//     foregroundColor: Colors.white,
//   ),
//   textTheme: const TextTheme(
//     bodyMedium: TextStyle(color: Colors.white),
//     headlineMedium: TextStyle(color: Colors.white),
//   ),
//   iconTheme: const IconThemeData(color: Colors.white70),
// );

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.transparent, 
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.third_color,
    brightness: Brightness.light,
  ).copyWith(
    onSurface: AppColors.l_text_clr, 
    primary: AppColors.third_color,
    surface: AppColors.container, 
  ),
  appBarTheme: AppBarTheme( 
    backgroundColor: AppColors.bottom_nav_color, 
    foregroundColor: AppColors.l_text_clr, 
  ),
  textTheme: TextTheme( 
    bodyMedium: TextStyle(color: AppColors.l_text_clr),
    headlineMedium: TextStyle(color: AppColors.l_text_clr),
  ),
  iconTheme: IconThemeData(color: AppColors.l_text_clr),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.bottom_nav_color,
    selectedItemColor: AppColors.third_color,
    unselectedItemColor: AppColors.l_text_clr2,
  ),
);

// --- Dark Theme Definition ---
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.transparent, 
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.third_color,
    brightness: Brightness.dark,
  ).copyWith(
    onSurface: AppColors.text_color, 
    primary: AppColors.third_color,
    surface: AppColors.containers_bgd,
  ),
  
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.containers_bgd,
    foregroundColor: AppColors.text_color, 
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: AppColors.text_color),
    headlineMedium: TextStyle(color: AppColors.text_color),
  ),
  iconTheme: IconThemeData(color: AppColors.text_color),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.containers_bgd,
    selectedItemColor: AppColors.third_color,
    unselectedItemColor: AppColors.secendary_text_color,
  ),
);