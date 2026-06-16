// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';

class Subscription extends StatelessWidget {
  final dynamic controller; 

  const Subscription({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
        gradient: isDarkMode
          ? LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [
              AppColors.containers_bgd,
              AppColors.containers_bgd.withOpacity(0.7), 
              Colors.transparent, 
            ],
          )
          : null, 
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: SvgPicture.asset(
                        isDarkMode? 'assets/icons/arrow_back.svg': 'assets/icons/arrow_back_light.svg',
                        width: 37.w,
                        height: 37.h,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: SvgPicture.asset(
                        isDarkMode?'assets/icons/theme_dark.svg':'assets/icons/light_theme.svg',
                        width:37.w,
                        height: 37.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Image.asset(
                  'assets/images/premium_logo.png',
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Welcome To',
                  style: GoogleFonts.lora(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                    color: isDarkMode?Colors.white:AppColors.heading_color,
                  ),
                ),
                SizedBox(height: 12.h),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.lora(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    children:[
                      TextSpan(text: 'Infini ',style: TextStyle(color: isDarkMode?Colors.white:AppColors.heading_color)),
                      TextSpan(
                        text: 'Quote',
                        style: TextStyle(color: Color(0xFFFFB703)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Start Your 14 Day\nFree Trial',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lora(
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFFB703),
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'Unlock Daily Wisdom, Premium Reminders,\nSaved Inspiration, And Deeper\nPersonal Insights.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300,
                    height: 1.4,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                SizedBox(height: 28.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color:  isDarkMode?Color(0xFF0F172A).withOpacity(0.9):Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: const Color(0xFFFFB703).withOpacity(0.4),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildFeatureItem(
                        context,
                        Icons.auto_awesome,
                        'Unlimited Daily Inspiration',
                      ),
                      _buildFeatureItem(
                        context,
                        Icons.calendar_today_rounded,
                        'Smart Event Reminders',
                      ),
                      _buildFeatureItem(
                        context,
                        Icons.local_offer_outlined,
                        'Save Your Favorite Quotes',
                      ),
                      _buildFeatureItem(
                        context,
                        Icons.brightness_3_outlined,
                        'Premium Calming Backgrounds',
                      ),
                      _buildFeatureItem(
                        context,
                        Icons.notifications_none_outlined,
                        'Personal Notification Messages',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 18.h,
                  ),
                  decoration: BoxDecoration(
                    color:  isDarkMode?Color(0xFF0F172A).withOpacity(0.9):Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: const Color(0xFFFFB703),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '14 Days Free',
                              style: GoogleFonts.lora(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFFB703),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                                children:[
                                  TextSpan(text: 'Then ',style: TextStyle(color:isDarkMode? AppColors.background_color:AppColors.heading_color)),
                                  TextSpan(
                                    text: '\$1.99',
                                    style: TextStyle(
                                      color: Color(0xFFFFB703),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(text: ' /Month',style: TextStyle(color:isDarkMode? AppColors.background_color:AppColors.heading_color)),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Color(0xFF10B981),
                                  size: 16,
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    'No Charge Today',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.sp,
                                      color: isDarkMode? AppColors.background_color:AppColors.heading_color,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Color(0xFF10B981),
                                  size: 16,
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    'Cancel Anytime',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.sp,
                                      color: isDarkMode? AppColors.background_color:AppColors.heading_color,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Image.asset(
                        'assets/images/crown.png',
                        width: 88.w,
                        height: 81.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                Container(
                  width: double.infinity,
                  height: 52.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Start Free Trial',
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Secondary Action Dismiss Button
                Text(
                  'May Be Later',
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: isDarkMode? AppColors.background_color:AppColors.heading_color,
                  ),
                ),
                SizedBox(height: 24.h),

                // Shield Verification Footer row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.security,
                      color: Color(0xFF10B981),
                      size: 14,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Safe & Secure',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: isDarkMode? AppColors.background_color:AppColors.heading_color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to construct list feature segments cleanly
  Widget _buildFeatureItem(BuildContext context,IconData icon, String text) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:  isDarkMode?Color(0xFF1E3A8A).withOpacity(0.3):AppColors.l_schedule_clr2,
            ),
            child: Icon(icon, color: const Color(0xFFFFB703), size: 18.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: isDarkMode?Colors.white:AppColors.heading_color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}