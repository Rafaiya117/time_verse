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

  const CustomHeaderBar({
    super.key,
    required this.title,
    required this.leftSpacing,
    required this.rightSpacing,
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
                context.pop();
              },
              icon: SvgPicture.asset(
                'assets/icons/arrow_back.svg',
                width: 37.w,
                height: 37.h,
                // ignore: deprecated_member_use
                //color: isDarkMode ? AppColors.text_color : AppColors.heading_color,
              ),
            ),
            SizedBox(width: leftSpacing),
            Text(
              title,
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.bold,
                fontSize: 17.sp,
                color: isDarkMode ? AppColors.text_color : AppColors.heading_color,
              ),
            ),
            SizedBox(width: rightSpacing),
            IconButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              icon: SvgPicture.asset(
                isDarkMode ? 'assets/icons/theme_dark.svg' : 'assets/icons/light_theme.svg',
                width: 37.w,
                height: 37.h,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h,),
        Row(
          children: [
            // Left divider line
            Expanded(
              child: Container(
                height: 1, // Total line thickness
                margin: EdgeInsets.only(right: 12.w), // Space before text
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.0,), // Fades out completely at outer edge
                      Colors.white.withOpacity(0.65,), // Solid/visible near the text
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/icons/sparkle.svg',
              height:14.h ,
              width:14.w,
            ),
            Expanded(
              child: Container(
                height: 1,
                margin: EdgeInsets.only(left: 12.w), // Space after text
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                  colors: [
                  Colors.white.withOpacity(0.55,), // Solid/visible near the text
                    Colors.white.withOpacity(0.0,), // Fades out completely at outer edge
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
