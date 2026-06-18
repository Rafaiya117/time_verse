// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/core/components/mood_tracker/controller.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/settings/profile/controller/profile_controller.dart';

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

  // Helper method to determine greeting text based on current hour
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // Helper method to format current date (e.g., "Tuesday, May 19")
  String _getFormattedDate() {
    final now = DateTime.now();
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.read<ProfileController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.loadUserProfile();
    });
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.r),
          child: SizedBox(
            child: Stack(

              children: [
                // 1. Blur & Darkening Overlay Layer
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 39, 46, 56).withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(32.r),
                        border: Border.all(
                          color: const Color(0xFFC5A880).withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                // 2. Foreground Content Layer
                Container(
                  padding: EdgeInsets.all(24.w),
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
                                    color: Colors.white.withValues(alpha: 0.03),
                                    border: Border.all(
                                      color: const Color(0xFFC5A880).withValues(alpha: 0.2),
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
                            
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Text(
                                  '✨ ',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                Text(
                                  _getGreeting(),
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFFFFB800),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 6.h),
                            Consumer<ProfileController>(
                              builder: (context, controller, _) {
                                final username = controller.currentUser?.name ??
                                UserSession().formattedUsername;
                                debugPrint('#### $username');
                                return Text(
                                  username,
                                  style: GoogleFonts.playfairDisplay(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 34.sp,
                                    color: AppColors.fourth_color,
                                  ),
                                );
                              },
                            ),                            
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '📅',
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    _getFormattedDate(),
                                    style: GoogleFonts.outfit(
                                      color: Colors.white70,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(height: 28.h),
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
                                          ? const Color(0xFFC5A880).withValues(alpha: 0.12)
                                          : Colors.white.withValues(alpha: 0.02),
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFC5A880)
                                            : Colors.white.withValues(alpha: 0.05),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}