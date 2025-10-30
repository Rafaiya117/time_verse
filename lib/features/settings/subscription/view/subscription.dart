import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_cards.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/settings/subscription/controller/subscription_controller.dart';

class Subscription extends StatelessWidget {
  final SubscriptionController controller;
  const Subscription({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomHeaderBar(
              title: 'Premium',
              leftSpacing: 90.w,
              rightSpacing: 83.w,
              ),
              SizedBox(height: 20.h),
              Image.asset(
                'assets/images/premium_logo.png',
                width: 144.w,
                height: 144.h,
              ),
              SizedBox(height: 20.h),
              Text(
                'Hemerolog Premium',
                style: GoogleFonts.outfit(
                  fontSize: 20.4.sp,
                  fontWeight: FontWeight.normal,
                  color: isDarkMode
                      ? AppColors.text_color
                      : const Color(0xFF373F4B),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Unlock the full cosmic experience',
                style: GoogleFonts.outfit(
                  fontSize: 11.9.sp,
                  fontWeight: FontWeight.normal,
                  color: isDarkMode
                      ? AppColors.text_color
                      : const Color(0xFF373F4B),
                ),
              ),
              SizedBox(height: 24.h),

              // 🔹 Subscription Cards
              Consumer<SubscriptionController>(
                builder: (context, controller, _) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => controller.selectCard(0),
                        child: PhaseCard(
                          title: 'Phase 1 : Free',
                          subtitle: 'User Acquisition and Retention',
                          isDarkMode: isDarkMode,
                          isSelected: controller.isCardSelected(0),
                          buttonText: 'Pay Now',
                          onButtonPressed: () {
                            print('Phase 1 payment tapped');
                          },
                          items: [
                            {
                              'title': '1. App Store Optimization (ASO)',
                              'details':
                                  '• Monitor download numbers daily\n'
                                  '• Respond to any initial reviews\n'
                                  '• Update screenshots based on feedback',
                            },
                            {
                              'title': '2. Initial User Support',
                              'details':
                                  '• Set up a simple support email\n'
                                  '• Create a FAQ section in-app',
                            },
                            {
                              'title': '3. Basic Analytics',
                              'details':
                                  '• Track daily active users\n'
                                  '• Monitor API usage\n'
                                  '• Identify crash reports',
                            },
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () => controller.selectCard(1),
                        child: PhaseCard(
                          title: 'Phase 2: First Month (2–4)',
                          subtitle: 'User Acquisition and Retention',
                          isDarkMode: isDarkMode,
                          isSelected: controller.isCardSelected(1),
                          buttonText: 'Upgrade',
                          onButtonPressed: () {
                            print('Phase 2 payment tapped');
                          },
                          items: [
                            {
                              'title': '1. Marketing Basics',
                              'details':
                                  '• Share on social media\n'
                                  '• Tell friends/family to download and review\n'
                                  '• Submit to app review sites',
                            },
                            {
                              'title': '2. Gather Feedback',
                              'details':
                                  '• Monitor user behavior patterns\n'
                                  '• Add feedback button\n'
                                  '• Identify most-used features',
                            },
                            {
                              'title': '3. Cost Management',
                              'details':
                                  '• Track DAU (Firebase Analytics)\n'
                                  '• Set API budget alerts\n'
                                  '• Monitor Firebase usage',
                            },
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Start 7-Day Free Trial',
                        style: GoogleFonts.inter(
                          fontSize:13.6.sp,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? AppColors.text_color
                              : const Color(0xFF373F4B),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Subcription will automatically renew. Cancel\n anytime.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize:10.2.sp,
                          fontWeight: FontWeight.normal,
                          color: isDarkMode
                            ? AppColors.text_color
                            : const Color(0xFF373F4B),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/shield.svg',
                            width:10.67.w,
                            height: 13.33.h,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Secure Payment Processing',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize:10.2.sp,
                              fontWeight: FontWeight.normal,
                              color: isDarkMode
                                ? AppColors.text_color
                                : const Color(0xFF373F4B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
