import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BulletButton extends StatelessWidget {
  final String label;
  final Color color;
  final String iconPath;

  const BulletButton({
    Key? key,
    required this.label,
    required this.color,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 125.w,
      height: 44.h,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 14.sp,
              height: 14.sp,
              color: color,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: color,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
