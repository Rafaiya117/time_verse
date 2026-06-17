import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/mood_tracker/controller.dart';

class MoodTrackerPopup extends StatelessWidget {
  const MoodTrackerPopup({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const MoodTrackerPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xFF060B13).withOpacity(0.75),
                borderRadius: BorderRadius.circular(32.r),
                border: Border.all(
                  color: const Color(0xFFC5A880).withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: Consumer<MoodController>(
                  builder: (context, controller, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.03),
                                border: Border.all(
                                  color: const Color(0xFFC5A880).withOpacity(0.2),
                                ),
                              ),
                              child: Icon(
                                Icons.nightlight_round_outlined,
                                color: const Color(0xFFC5A880),
                                size: 24.w,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                'Skip',
                                style: GoogleFonts.outfit(
                                  color: Colors.white54,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          "What's your mood\ntoday?",
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Your emotion helps AI generate a more personal quote and peaceful daily guidance.",
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF9EACBA),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.moods.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 0.72,
                          ),
                          itemBuilder: (context, index) {
                            final mood = controller.moods[index];
                            final isSelected = index == controller.selectedIndex;

                            return GestureDetector(
                              onTap: () async {
                                controller.updateSelectedIndex(index);
                                
                                // Dispatching post payload mutation via current string labels
                                final label = mood['label'] as String;
                                await controller.postMoodToApi(label);

                                await Future.delayed(const Duration(milliseconds: 250));
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                    ? const Color(0xFFC5A880).withOpacity(0.12)
                                    : Colors.white.withOpacity(0.02),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: isSelected
                                    ? const Color(0xFFC5A880)
                                    : Colors.white.withOpacity(0.05),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      mood['emoji'] as String,
                                      style: TextStyle(fontSize: 26.sp),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      mood['label'] as String,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        color: isSelected ? Colors.white : Colors.white70,
                                        fontSize: 11.sp,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}