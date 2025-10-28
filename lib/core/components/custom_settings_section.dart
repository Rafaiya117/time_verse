import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/core/utils/colors.dart';
class SettingsItem {
  final String label;
  final VoidCallback onTap;

  SettingsItem({required this.label, required this.onTap});
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsItem> items;

  const SettingsSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDarkMode?AppColors.third_color: AppColors.l_text_clr2,
          ),
        ),
        SizedBox(height: 12.h),
        ...items.map((item) => InkWell(
              onTap: item.onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:12.0),
                      child: Text(
                        item.label,
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          color: isDarkMode?AppColors.text_color: AppColors.l_text_clr2,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                      color: isDarkMode?AppColors.third_color: AppColors.l_text_clr2,
                    ),
                  ],
                ),
              ),
            )
          ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
