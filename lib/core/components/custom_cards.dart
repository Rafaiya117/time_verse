import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/utils/colors.dart';

class PhaseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Map<String, dynamic>> items;
  final bool isDarkMode;
  final bool isSelected;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const PhaseCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.isDarkMode,
    this.isSelected = false,
    this.buttonText,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 312.w,
          height: 483.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: isDarkMode ? AppColors.text_color : const Color(0xFFCECECE),
              width: 1.0.w,
            ),
            borderRadius: BorderRadius.circular(4.0.r),
            color: isDarkMode ? const Color(0xFF1A1F3A) : const Color(0xFFF4F6F5),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: isDarkMode
                      ? AppColors.text_color
                      : const Color(0xFF373F4B),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: isDarkMode
                      ? AppColors.text_color
                      : const Color(0xFF373F4B),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/subscription_bullet.svg',
                      width: 16.w,
                      height: 16.h,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: items.map((item) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                        ? AppColors.text_color
                                        : const Color(0xFF373F4B),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  item['details'],
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.normal,
                                    color: isDarkMode
                                        ? AppColors.text_color
                                        : const Color(0xFF373F4B),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (isSelected && buttonText != null)
              Center(
                child: CustomButton(
                  text: "Payment",
                    onPressed: () {
                      //context.push('/signup');
                      //context.push('/settings');
                    },
                    gradient: AppGradientColors.button_gradient,
                    textColor: AppColors.text_color,
                    fontFamily: 'outfit',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    height: 51.h,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 1.h,
          right: 1.w,
          child: SvgPicture.asset(
            'assets/icons/corner_icon.svg',
            width: 80.w,
            height: 80.h,
          ),
        ),
      ],
    );
  }
}
