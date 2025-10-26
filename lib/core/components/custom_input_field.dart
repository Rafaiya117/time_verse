import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.fontSize = 12,
    this.textColor,
    this.borderColor,
    this.labelColor,
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
                    (isDarkMode ? AppColors.text_color: AppColors.heading_color),
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
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          decoration: InputDecoration(
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
                width: 1.5.w,
              ),
            ),
            labelText: widget.hintText,
            labelStyle: GoogleFonts.outfit(
              fontSize: (widget.fontSize - 2).sp,
              fontWeight: FontWeight.normal,
              color: widget.labelColor ?? AppColors.heading_color,
            ),
            suffixIcon: widget.isPassword
              ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.heading_color,
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
      ],
    );
  }
}
