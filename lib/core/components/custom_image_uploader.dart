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
    this.title = 'Upload your photo',
    this.subtitle = 'JPG, PNG up to 5MB',
    this.width =double.infinity, //327,
    this.height = 62,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: CustomPathDottedBorderOptions(
          padding: EdgeInsets.zero,
          color: isDark ? Colors.orange : Colors.grey,
          strokeWidth: 1,
          dashPattern: [6, 3],
          customPath: (size) => Path()
            ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(0, 0, size.width, size.height),
              Radius.circular(4.0),
            ),
          ),
        ),
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.containers_bgd : AppColors.background_color,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                svgAsset,
                width: 40.w,
                height: 32.h,
                colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
              ),
              SizedBox(width: 8),
              Flexible(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.third_color,
                    ),
                    children: [
                      TextSpan(text: '$title\n'),
                      TextSpan(
                        text: subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
