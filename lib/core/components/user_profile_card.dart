import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfileCard extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final bool isPremium;
  final String subtitle;
  final VoidCallback onTap;

  const UserProfileCard({
    super.key,
    required this.imageUrl,
    required this.userName,
    required this.isPremium,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // Dark theme background surface color palette matching design canvas
        color: isDarkMode ? const Color(0xFF0B1528) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          // Subtle Amber-gold transparent luxury border ring seen in dark mockup view
          color: isDarkMode 
              ? const Color(0xFFFFB703).withOpacity(0.2) 
              : const Color(0xFFE5E7EB),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
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
            padding: EdgeInsets.all(14.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Left Section: User Avatar Image Frame (With smooth curved squircle corners)
                Container(
                  width: 64.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),

                // 2. Center Section: Dynamic Backend Text Fields Stack
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Display Name Text Node
                      Text(
                        userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      
                      // Conditional Dynamic Membership Status Sub-Row
                      Row(
                        children: [
                          Text(
                            isPremium ? '👑 ' : '',
                            style: TextStyle(fontSize: 13.sp),
                          ),
                          Text(
                            isPremium ? 'Premium Member' : 'Free Tier Account',
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              // Gold Theme Text Color matching design asset specs
                              color: const Color(0xFFFFB703), 
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // User Account Subtitle description text block
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

                // 3. Right Section: Linear Trailing Dynamic Forward Arrow Icon Indicator
                Icon(
                  Icons.arrow_right_alt_rounded,
                  color: const Color(0xFFFFB703),
                  size: 26.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}