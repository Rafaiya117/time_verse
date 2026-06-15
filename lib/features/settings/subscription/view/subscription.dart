// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';

class Subscription extends StatelessWidget {
  final dynamic controller; // Kept your controller integration intact

  const Subscription({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Full-screen background gradient matching the dark atmospheric theme
        decoration:BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [
              AppColors.containers_bgd, 
              AppColors.containers_bgd.withOpacity(0.7),// Color at the very bottom
              Colors.transparent, // Color at the center
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Navigation Bar (Back Arrow Button and Sun/Theme Icon)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFFFFF).withOpacity(0.06),
                          border: Border.all(
                            color: const Color(0xFFFFFFFF).withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: SvgPicture.asset(
                        'assets/icons/theme_dark.svg',
                        width:37.w,
                        height: 37.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),

                // Top Rose Premium Logo
                Image.asset(
                  'assets/images/premium_logo.png',
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 12.h),

                // Header Labels
                Text(
                  'Welcome To',
                  style: GoogleFonts.lora(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
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
                    children: const [
                      TextSpan(text: 'Infini '),
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

                // Premium Features Blueprint List Container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: const Color(0xFFFFB703).withOpacity(0.4),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildFeatureItem(
                        Icons.auto_awesome,
                        'Unlimited Daily Inspiration',
                      ),
                      _buildFeatureItem(
                        Icons.calendar_today_rounded,
                        'Smart Event Reminders',
                      ),
                      _buildFeatureItem(
                        Icons.local_offer_outlined,
                        'Save Your Favorite Quotes',
                      ),
                      _buildFeatureItem(
                        Icons.brightness_3_outlined,
                        'Premium Calming Backgrounds',
                      ),
                      _buildFeatureItem(
                        Icons.notifications_none_outlined,
                        'Personal Notification Messages',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),

                // Pricing Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 18.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withOpacity(0.9),
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
                                children: const [
                                  TextSpan(text: 'Then '),
                                  TextSpan(
                                    text: '\$1.99',
                                    style: TextStyle(
                                      color: Color(0xFFFFB703),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(text: ' /Month'),
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
                                      color: Colors.white70,
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
                                      color: Colors.white70,
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

                // CTA Button - Start Free Trial
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
                    color: Colors.white60,
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
                        color: Colors.white54,
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
  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1E3A8A).withOpacity(0.3),
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
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}