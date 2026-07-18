// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';

class CustomHeaderBar extends StatelessWidget {
  final String title;
  final double leftSpacing;
  final double rightSpacing;
  final bool showLeftLine;
  final bool showRightLine;
  final VoidCallback? onBackPressed; 

  const CustomHeaderBar({
    super.key,
    required this.title,
    required this.leftSpacing,
    required this.rightSpacing,
    this.showLeftLine = true,
    this.showRightLine = true,
    this.onBackPressed, 
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                if (onBackPressed != null) {
                  onBackPressed!();
                } else {
                  context.pop();
                }
              },
              icon: SvgPicture.asset(
                isDarkMode ? 'assets/icons/arrow_back.svg' : 'assets/icons/arrow_back_light.svg',
                width: 37.w,
                height: 37.h,
              ),
            ),
            SizedBox(width: leftSpacing),
            Text(
              title,
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.bold,
                fontSize: 17.sp,
                color: isDarkMode
                ? AppColors.text_color
                : AppColors.heading_color,
              ),
            ),
            SizedBox(width: rightSpacing),
            IconButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              icon: SvgPicture.asset(
                isDarkMode
                ? 'assets/icons/theme_dark.svg'
                : 'assets/icons/light_theme.svg',
                width: 37.w,
                height: 37.h,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            if (showLeftLine)
              Expanded(
                child: Container(
                  height: 1,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: Theme.of(context).brightness == Brightness.light
                      ? [
                        const Color(0xFF878787).withOpacity(0.0),
                        const Color(0xFFD9D9D9),
                      ]
                      : [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.65),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            SvgPicture.asset(
              'assets/icons/sparkle.svg',
              height: 14.h,
              width: 14.w,
            ),
            if (showRightLine)
              Expanded(
                child: Container(
                  height: 1,
                  margin: EdgeInsets.only(left: 12.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: Theme.of(context).brightness == Brightness.light
                      ? [
                        const Color(0xFFD9D9D9),
                        const Color(0xFF878787).withOpacity(0.0),
                      ]
                      : [
                        Colors.white.withOpacity(0.65),
                        Colors.white.withOpacity(0.0),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}