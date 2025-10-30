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

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            context.pop();
          },
          icon: SvgPicture.asset(
            'assets/icons/arrow_back.svg',
            width: 17.5.w,
            height: 15.01.h,
            // ignore: deprecated_member_use
            color: isDarkMode ? AppColors.text_color : AppColors.heading_color,
          ),
        ),
        SizedBox(width: leftSpacing),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
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
            width: 15.w,
            height: 15.h,
          ),
        ),
      ],
    );
  }
}
