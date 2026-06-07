import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialAuthButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onTap;

  const SocialAuthButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), 
        child: Container(
          width: double.infinity,
          height: 52.h,
          decoration: BoxDecoration(
            // Translucent dark background matching the image
            color: Colors.black.withOpacity(0.4), 
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              // Slim, subtle tinted border border
              color: const Color(0xFFC5A880).withOpacity(0.25), 
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: icon,
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      text,
                      style: GoogleFonts.outfit(
                        color: const Color(0xFFE0E0E0), // Muted off-white text
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}