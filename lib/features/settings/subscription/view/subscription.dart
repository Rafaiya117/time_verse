import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/core/components/custom_cards.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/settings/subscription/controller/subscription_controller.dart';

class Subscription extends StatelessWidget {
  final SubscriptionController controller;
  const Subscription({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Load offerings once after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadOfferings();
    });

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomHeaderBar(
                title: 'Premium',
                leftSpacing: 90.w,
                rightSpacing: 80.w,
              ),
              SizedBox(height: 20.h),
              Image.asset(
                'assets/images/premium_logo.png',
                width: 144.w,
                height: 144.h,
              ),
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.outfit(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      children: [
                        const TextSpan(text: 'Start Your 14 Day\n'),
                        TextSpan(
                          text: 'Free Trial',
                          style: TextStyle(color: const Color(0xFFFFB703)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h), // Precise vertical spacing
                  Text(
                    'Unlock Daily Wisdom, Premium Reminders,\nSaved Inspiration, And Deeper\nPersonal Insights.', // Corrected exact multi-line text block from image
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp, // Body text size matching reference
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: isDarkMode
                      ? const Color(0xFFE5E7EB)
                      : const Color(0xFF4B5563,), // Neutral ash gray color from assets
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  final packages = controller.availablePackages;
                  if (packages.isEmpty) {
                    Widget buildFeatureRow(Widget iconWidget, String text) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 46.w,
                              height: 46.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF031130), 
                                border: Border.all(
                                  // ignore: deprecated_member_use
                                  color: const Color(0xFFFFB703).withOpacity(0.3), // Thin gold accent circular ring
                                  width: 1,
                                ),
                              ),
                              child: Center(child: iconWidget),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: Text(
                                text,
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isDarkMode ?const Color(0xFFFFB703):AppColors.l_text_clr2, 
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode?const Color(0xFF061124): AppColors.l_schedule_clr1, 
                        borderRadius: BorderRadius.circular(28.r), 
                        border: Border.all(
                          // ignore: deprecated_member_use
                          color: isDarkMode ?const Color(0xFFFFB703).withOpacity(0.5):AppColors.new_clr, 
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildFeatureRow(
                            Icon(
                              Icons.auto_awesome,
                              color: const Color(0xFFFFB703),
                              size: 20.sp,
                            ), // Gold sparkle vectors
                            'Unlimited Daily Inspiration',
                          ),
                          buildFeatureRow(
                            Icon(
                              Icons.calendar_today_rounded,
                              color: const Color(0xFF60A5FA),
                              size: 20.sp,
                            ), // Soft light-blue calendar
                            'Smart Event Reminders',
                          ),
                          buildFeatureRow(
                            Transform.rotate(
                              angle: -0.2,
                              child: Icon(
                                Icons.bookmark_added_rounded,
                                color: const Color(0xFFE5E7EB),
                                size: 20.sp,
                              ), // Quote/Bookmark icon symbol
                            ),
                            'Save Your Favorite Quotes',
                          ),
                          buildFeatureRow(
                            Icon(
                              Icons.nightlight_round,
                              color: const Color(0xFFFFB703),
                              size: 20.sp,
                            ), // Warm glowing moon vector
                            'Premium Calming Backgrounds',
                          ),
                          buildFeatureRow(
                            Icon(
                              Icons.nightlight_round,
                              color: const Color(0xFFFFB703),
                              size: 20.sp,
                            ), // Matching identical crescent moon graphic
                            'Personal Notification Messages',
                          ),
                        ],
                      ),
                    );
                  }
                  debugPrint(
                    '*********** Available Packages: ${packages.length} ***********',
                  );
                  return Column(
                    children: List.generate(packages.length, (index) {
                      final package = packages[index];
                      final isSelected = controller.isCardSelected(index);
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => controller.selectCard(index),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 22.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Color(0xFF020611),
                                    Color(0xFF091222),
                                    Color(0xFF111E35),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: isSelected? const Color(0xFFFFB703): Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    package.storeProduct.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 22.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    package.storeProduct.priceString,
                                    style: GoogleFonts.outfit(
                                      fontSize: 22.sp,
                                      color: const Color(0xFFFFB703),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      );
                    }),
                  );
                },
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: isDarkMode ?const Color(0xFFFFB703):AppColors.l_schedule_clr1,
                  borderRadius: BorderRadius.circular(24.r,), 
                  border: Border.all(
                    color: const Color(0xFFFFB703,), 
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '14 Days Free',
                                style: GoogleFonts.outfit(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFFB703), 
                                ),
                              ),
                              SizedBox(height: 6.h),
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Then '),
                                    TextSpan(
                                      text: '\$1.99',
                                      style: TextStyle(
                                        color: const Color(0xFFFFB703), // Bold accent pricing
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                    const TextSpan(text: ' /Month'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right Side: Double-bordered circular crown graphic
                        Container(
                          width: 72.w,
                          height: 72.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF040A15),
                            border: Border.all(
                              color: const Color(0xFFFFB703),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: const Color(0xFFFFB703).withOpacity(0.15),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    // ignore: deprecated_member_use
                                    color: const Color(0xFFFFB703).withOpacity(0.4),
                                    width: 1,
                                  ),
                                ),
                              ),
                              // Crown Icon Component
                              Icon(
                                Icons.star_border,
                                color: const Color(0xFFFFB703),
                                size: 36.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              color: const Color(0xFF10B981), 
                              size: 18.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'No Charge Today',
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Shield feature 2
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              color: const Color(0xFF10B981), // Vivid system emerald green
                              size: 18.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Cancel Anytime',
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                height: 54.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFFA9600), Color(0xFFD9831A)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFA9600).withOpacity(0.35),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(14.r),
                    child: Center(
                      child: Text(
                        'Start Free Trial',
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600, 
                          color: Colors.black, 
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'May Be Later',
                style: GoogleFonts.inter(
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                  ? AppColors.text_color
                  : const Color(0xFF373F4B),
                ),
              ),
              SizedBox(height: 20.h),
              // Text(
              //   'Subscription will automatically renew. Cancel\n anytime.',
              //   textAlign: TextAlign.center,
              //   style: GoogleFonts.inter(
              //     fontSize: 10.2.sp,
              //     fontWeight: FontWeight.normal,
              //     color: isDarkMode
              //       ? AppColors.text_color
              //       : const Color(0xFF373F4B),
              //   ),
              // ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/shield.svg',
                    width: 10.67.w,
                    height: 13.33.h,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Safe & Secure',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 10.2.sp,
                      fontWeight: FontWeight.normal,
                      color: isDarkMode
                        ? AppColors.text_color
                        : const Color(0xFF373F4B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
