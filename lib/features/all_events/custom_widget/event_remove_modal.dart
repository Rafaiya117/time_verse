import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


void showRemoveEventDialog(BuildContext context, {required VoidCallback onConfirm}) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        // ✅ FIX: Modal background color matches the warm/cream tint in light mode
        backgroundColor: isDarkMode ? const Color(0xFF060B13) : const Color(0xFFFAF6F0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ FIX: Accurate vibrant red circle outline icon from image
              Icon(
                Icons.error_outline_rounded, 
                color: const Color(0xFFE52525), 
                size: 44.sp,
              ),
              SizedBox(height: 18.h),
              
              Text(
                'Are you sure you want to\nRemove this Event?',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 20.sp, 
                  fontWeight: FontWeight.w700,
                  // ✅ FIX: Deep navy/charcoal text color for light mode title
                  color: isDarkMode ? Colors.white : const Color(0xFF0C1923),
                  height: 1.3,
                ),
              ),
              SizedBox(height: 14.h),
              
              Text(
                'This action cannot be undone. Are you sure you want to continue?',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 13.sp, 
                  fontWeight: FontWeight.w400,
                  // ✅ FIX: Muted slate gray body text matching the image opacity
                  color: isDarkMode ? Colors.white60 : const Color(0xFF707070),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),
              
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: SizedBox(
                      height: 44.h,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          // ✅ FIX: Cancel button background is near-black/dark charcoal in light mode
                          backgroundColor: isDarkMode ? Colors.white : const Color(0xFF222222),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                            color: isDarkMode ? const Color(0xFF222222) : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  
                  // Remove Button
                  Expanded(
                    child: SizedBox(
                      height: 44.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          // ✅ FIX: Remove button background is bright vibrant cherry red
                          backgroundColor: const Color(0xFFE51C1C),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          'Remove',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}