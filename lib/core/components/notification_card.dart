import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TappableNotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int badgeCount;
  final VoidCallback onTap;

  const TappableNotificationCard({
    super.key,
    this.title = 'Notifications',
    this.subtitle = 'Manage alerts and reminders',
    this.badgeCount = 1,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0B1528) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDarkMode ? const Color(0xFFFFB703).withOpacity(0.15) : const Color(0xFFE5E7EB),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          splashColor: const Color(0xFFFFB703).withOpacity(0.1),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.notifications,
                      color: isDarkMode ? Colors.white : const Color(0xFFFFA500),
                      size: 26.sp,
                    ),
                    if (badgeCount > 0)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444), // Notification Alert Red
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 13.w,
                            minHeight: 13.h,
                          ),
                          child: Center(
                            child: Text(
                              '$badgeCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 16.w),
                // 2. Text Details Section
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),

                // 3. Right Side Custom Amber-Gold Action Arrow
                Icon(
                  Icons.arrow_right_alt_rounded,
                  color: const Color(0xFFFFB703),
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}