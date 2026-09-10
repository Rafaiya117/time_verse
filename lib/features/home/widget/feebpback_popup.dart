import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/features/home/controller/home_controller.dart';

void showFeedbackDialog(BuildContext context,bool isDarkMode,HomeController homeController) {
    homeController.clearFeedback();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<HomeController>(
          builder: (context, controller, child) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                width: 340.w,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF051123): const Color(0xFFFFF3D9),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Write your Feedback',
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : const Color(0xFF4A4A4A),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        int ratingValue = index + 1;
                        bool isSelected = ratingValue <= controller.selectedRating;
                        return GestureDetector(
                          onTap: () => controller.updateRating(ratingValue),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Icon(
                              // If selected, show solid star; otherwise, show the star outline
                              isSelected ? Icons.star : Icons.star_border,
                              color: const Color(0xFFFFB800),
                              size: 32.sp,
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Your Feedback:',
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode? Colors.white: const Color(0xFF4A4A4A),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      controller: controller.feedbackController,
                      maxLines: 4,
                      style: GoogleFonts.outfit(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF051123): Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB800).withValues(alpha: isDarkMode ? 0.5 : 1.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: Color(0xFFFFB800),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.submitFeedback();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode ? const Color(0xFFC69C3D): const Color(0xFFF39C12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isDarkMode ? 'Submit' : 'Submit Review',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }