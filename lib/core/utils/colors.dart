// app_colors.dart

import 'package:flutter/material.dart';

class AppColors{
  //!------------dark mood --------!
  static const text_color = Color(0xFFFFFFFF); 
  static const secendary_text_color = Color(0xFFA3A8C3);
  static const third_color = Color(0xFFDF951F);
  static const fourth_color = Color(0xFFFFA500);
  static const fifth_color = Color(0xFF00B383); 
  static const containers_bgd = Color(0xFF051123);
  static const button_color  = Color(0xFFCBA135);
  static const color_danger  = Color(0xFFF87171); 

  //!------------light mood --------!
  static const background_color = Color(0xFFFFF7ED);
  static const l_text_clr = Color(0xFF051E37);
  static const l_text_clr2 = Color(0xFF373F4B);          
  static const l_schedule_clr1 = Color(0xFFF0FDF4);
  static const l_schedule_clr2 = Color(0xFFEFF6FF);
  static const l_schedule_clr3 = Color(0xFFFFEFFE);
  static const save_color = Color(0xFF1447E6);
  static const share_text =  Color(0xFFCA3500);   
  static const bottom_nav_color = Color(0xFFB4AB9C);
  static const container = Color(0xFFCECECE);                                               
  static const heading_color = Color(0xFF504D4A);
  static Color getDynamicTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
      ? AppColors.text_color 
      : AppColors.l_text_clr; 
  }
}

class AppGradientColors{
  static const button_gradient = LinearGradient(
    colors: [
      Color(0xFFFFA500),
      Color(0xFFD4902A)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight
  );
}