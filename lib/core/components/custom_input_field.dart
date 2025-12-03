import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/core/utils/colors.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final double fontSize;
  final Color? textColor;
  final Color? borderColor;
  final Color? labelColor;
  final double? height;
  final double? hintFontSize;
  final String? prefixSvgPath; // ✅ added
  final Color? prefixIconColor;
  final Color? suffixIconColor;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.fontSize = 14,
    this.textColor,
    this.borderColor,
    this.labelColor,
    this.height,
    this.hintFontSize,
    this.prefixSvgPath, // ✅ added
    this.prefixIconColor,
    this.suffixIconColor,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.label.replaceAll('*', ''),
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  fontSize: widget.fontSize.sp,
                  color: widget.textColor ??
                    (isDarkMode ? AppColors.text_color : AppColors.heading_color),
                ),
              ),
              if (widget.label.contains('*'))
                TextSpan(
                  text: '*',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: widget.fontSize.sp,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        SizedBox(
          height: widget.height ?? 40.h,
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 8.w),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.third_color,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.third_color,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.third_color,
                  width: 1.0.w,
                ),
              ),
              labelText: widget.hintText,
              labelStyle: GoogleFonts.outfit(
                fontSize: widget.hintFontSize ?? 10.sp,
                fontWeight: FontWeight.normal,
                color: widget.labelColor ??(isDarkMode ? AppColors.text_color : const Color(0xFF353535)),
              ),
              prefixIcon: widget.prefixSvgPath != null
                ? Padding(
                  padding: EdgeInsets.all(16.0),
                    child: SvgPicture.asset(
                      widget.prefixSvgPath!,
                      width: 14.w,
                      height: 16.h,
                      colorFilter: ColorFilter.mode(
                        widget.prefixIconColor ?? AppColors.text_color,
                      BlendMode.srcIn,
                    ),
                  ),
                )
                : null,
                suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: widget.suffixIconColor ?? AppColors.text_color,
                        size: 11.sp,
                    ),
                    onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
            ),
          ),
        ),
      ],
    );
  }
}
