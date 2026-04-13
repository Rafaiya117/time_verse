import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/core/utils/colors.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final double fontSize;
  final double? height;
  final Color? textColor;
  final Color? borderColor;
  final Color? labelColor;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
    this.fontSize = 14,
    this.height,
    this.textColor,
    this.borderColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Reusing your logic for the Label with the '*' check
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label.replaceAll('*', ''),
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize.sp,
                  color: textColor ?? (isDarkMode ? Colors.white70 : Colors.black87),
                ),
              ),
              if (label.contains('*'))
                TextSpan(
                  text: '*',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize.sp,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        SizedBox(
          height: height ?? 48.h, // Slightly taller usually feels better for dropdowns
          child: DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            icon: Icon(Icons.keyboard_arrow_down, size: 20.sp),
            alignment: Alignment.centerLeft,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 8.w),
              hintText: hintText,
              hintStyle: GoogleFonts.outfit(
                fontSize: 12.sp,
                color: labelColor ?? (isDarkMode ? Colors.white38 : Colors.grey),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? AppColors.third_color),
                borderRadius: BorderRadius.circular(8.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? AppColors.third_color),
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? Colors.blue),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            // Styling the text inside the dropdown
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}