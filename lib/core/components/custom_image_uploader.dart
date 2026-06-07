import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/core/utils/colors.dart';

class ImagePickerBox extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final double width;
  final double height;
  final String svgAsset;

  const ImagePickerBox({
    super.key,
    required this.onTap,
    required this.svgAsset,
    this.title = 'Add profile Photo',
    this.subtitle = 'Optional • JPG/PNG up to 5MB',
    this.width = double.infinity,
    this.height = 110, 
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Colors.orange; // Replace with AppColors.third_color if needed

    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: CustomPathDottedBorderOptions(
          padding: EdgeInsets.zero,
          color: isDark ? primaryColor : Colors.grey,
          strokeWidth: 1.5,
          dashPattern: [4, 4],
          customPath: (size) => Path()
            ..addRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(0, 0, size.width, size.height),
                Radius.circular(12.r), // Softer corners to match the image
              ),
            ),
        ),
        child: Container(
          width: width,
          // REMOVED fixed height: height.h to prevent the bottom overflow completely
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.containers_bgd : AppColors.background_color,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Forces the column to wrap tightly around contents
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Styled Icon Wrapper Box
              SvgPicture.asset(
                svgAsset,
                width: 22.w,
                height: 22.h,
                colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
              ),
              SizedBox(height: 10.h),
              // Main Title Text
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 4.h),
              // Subtitle Text
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}