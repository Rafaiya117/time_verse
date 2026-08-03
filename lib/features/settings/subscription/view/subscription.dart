// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/settings/subscription/controller/subscription_controller.dart';

class Subscription extends StatelessWidget {
  final dynamic controller;

  const Subscription({super.key, required this.controller});
  Widget _getExactFeatureIcon(int index) {
    switch (index) {
      case 0:
        // Sparkles / Stars ✨
        return const Icon(
          Icons.auto_awesome,
          color: Color(0xFFFFC107),
          size: 18,
        );

      case 1:
        // Calendar with Blue Top Bar 📅
        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Column(
            children: [
              Container(
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      6,
                      (_) => Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF9CA3AF),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case 2:
        return Transform.rotate(
          angle: -0.7,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 12,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Positioned(
                top: 1,
                child: Container(
                  width: 3.5,
                  height: 3.5,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );

      case 3:
      case 4:
      default:
        return const Icon(
          Icons.nightlight_round,
          color: Color(0xFFFFC107),
          size: 18,
        );
    }
  }

  Widget _buildFeatureItem(BuildContext context, String text, int index) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          // Circular Badge with Gold Ring Border
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0B1528),
              border: Border.all(
                color: const Color(0xFFFFB703).withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Center(
              child: _getExactFeatureIcon(index),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: isDarkMode ? Colors.white : AppColors.heading_color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Safe check to prevent infinite re-render loops
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final subController = context.read<SubscriptionController>();
      if (subController.offerings == null) {
        subController.loadOfferings();
      }
    });

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
                // Top Action Bar
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
                        isDarkMode
                        ? 'assets/icons/arrow_back.svg' : 'assets/icons/arrow_back_light.svg',
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
                        isDarkMode ? 'assets/icons/theme_dark.svg' : 'assets/icons/light_theme.svg',
                        width: 37.w,
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
                    color: isDarkMode ? Colors.white : AppColors.heading_color,
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
                    children: [
                      TextSpan(
                        text: 'Infini ',
                        style: TextStyle(
                          color: isDarkMode
                          ? Colors.white
                          : AppColors.heading_color,
                        ),
                      ),
                      const TextSpan(
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

                // ✅ 1. Features Block Container
                Consumer<SubscriptionController>(
                  builder: (context, subController, child) {
                    final features = subController.offeringFeatures;
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                        ? const Color(0xFF0F172A).withOpacity(0.9)
                        : Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFFFFB703).withOpacity(0.4),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        children: List.generate(features.length, (index) {
                          return _buildFeatureItem(
                            context,
                            features[index],
                            index,
                          );
                        }),
                      ),
                    );
                  },
                ),
                SizedBox(height: 18.h),

                // ✅ 2. Pricing Box Container
                Consumer<SubscriptionController>(
                  builder: (context, subController, child) {
                    final package = subController.availablePackages.isNotEmpty
                    ? subController.availablePackages.first: null;
                    final priceString = package?.storeProduct.priceString ?? "\$1.99";
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 18.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF0F172A).withOpacity(0.9) : Colors.white,
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
                                    children: [
                                      TextSpan(
                                        text: 'Then ',
                                        style: TextStyle(
                                          color: isDarkMode
                                          ? AppColors.background_color
                                          : AppColors.heading_color,
                                        ),
                                      ),
                                      TextSpan(
                                        text: priceString,
                                        style: const TextStyle(
                                          color: Color(0xFFFFB703),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' /Month',
                                        style: TextStyle(
                                          color: isDarkMode
                                          ? AppColors.background_color
                                          : AppColors.heading_color,
                                        ),
                                      ),
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
                                          color: isDarkMode
                                          ? AppColors.background_color
                                          : AppColors.heading_color,
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
                                          color: isDarkMode ? AppColors.background_color : AppColors.heading_color,
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
                    );
                  },
                ),
                SizedBox(height: 22.h),
                // Main CTA Purchase Button
                Consumer<SubscriptionController>(
                  builder: (context, subController, child) {
                    return Container(
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
                        onPressed: subController.isPurchasing
                          ? null: () async {
                            final packages = subController.availablePackages;
                              if (packages.isNotEmpty) {
                                await subController.purchasePackage(packages.first);
                                if (!context.mounted) return;
                                if (subController.purchaseStatus == "success") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Subscription Active!"),
                                  ),
                                );
                                context.pop();
                                } else if (subController.purchaseStatus == "failed") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Purchase Failed. Please try again.",
                                    ),
                                  ),
                                );
                              }
                            } else {
                            await subController.loadOfferings();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: subController.isPurchasing
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                                'Start Free Trial',
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),

                // Secondary Action Dismiss Button
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Text(
                    'May Be Later',
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: isDarkMode
                          ? AppColors.background_color
                          : AppColors.heading_color,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
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
                        color: isDarkMode
                            ? AppColors.background_color
                            : AppColors.heading_color,
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
}