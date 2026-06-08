import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsItem {
  final String label;
  final String? subtitle; // Added to support descriptive layout rows
  final String? statusText;
  final String iconPath;
  final VoidCallback onTap;

  SettingsItem({
    required this.label,
    this.subtitle,
    this.statusText,
    required this.iconPath,
    required this.onTap,
  });
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsItem> items;
  final bool isDangerZone;

  const SettingsSection({
    super.key,
    required this.title,
    required this.items,
    this.isDangerZone = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final Color headerColor = isDangerZone ? const Color(0xFFEF4444) : (isDarkMode ? const Color(0xFFD97706) : const Color(0xFFB45309));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: headerColor,
            ),
          ),
        ),
        Column(
          children: items.map((item) {
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF0B1528) : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isDarkMode 
                  ? const Color(0xFFFFB703).withOpacity(0.15) 
                  : const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: InkWell(
                  onTap: item.onTap,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                    child: Row(
                      children: [
                        // Left Icon Asset
                        SvgPicture.asset(
                          item.iconPath,
                          width: 20.w,
                          height: 20.h,
                          colorFilter: ColorFilter.mode(
                            isDangerZone 
                            ? const Color(0xFFEF4444) 
                            : (isDarkMode ? Colors.white : const Color(0xFF1F2937)),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 14.w),                       
                        // Text Layout (Title + Subtitle)
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isDangerZone
                                  ? const Color(0xFFEF4444)
                                  : (isDarkMode ? Colors.white: const Color(0xFF1F2937)),
                                ),
                              ),
                              if (item.subtitle != null) ...[
                                SizedBox(height: 2.h),
                                Text(
                                  item.subtitle!,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: isDarkMode
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                              if (item.statusText != null) ...[
                                SizedBox(height: 4.h),
                                Text(
                                  item.statusText!,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFFFB703,), // Precise golden color from design assets
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.arrow_right_alt_rounded,
                          color: isDangerZone ? const Color(0xFFEF4444) : const Color(0xFFFFB703),
                          size: 26.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}