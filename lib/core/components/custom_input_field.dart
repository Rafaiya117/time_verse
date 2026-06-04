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
  final String? prefixSvgPath;
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
    this.prefixSvgPath,
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
                  color: widget.textColor ??(isDarkMode
                    ? AppColors.text_color
                    : AppColors.heading_color),
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
          height: widget.height ?? 45.h,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: const Color(0xFFDF951F),
                width: 1.w,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF020617), // top
                  Color(0xFF111827), // middle
                  Color(0xFF0F172A), // bottom
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color:const Color(0xFFDF951F).withValues(alpha: 0.12),
                  blurRadius: 6,
                  spreadRadius: 0.5,
                ),
              ],
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText:
                  widget.isPassword ? _obscureText : false,
              textAlignVertical: TextAlignVertical.center,

              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,

                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),

                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,

                hintText: widget.hintText,

                hintStyle: GoogleFonts.outfit(
                  fontSize:
                      widget.hintFontSize ?? 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9CA3AF),
                ),

                prefixIcon: widget.prefixSvgPath != null
                    ? Padding(
                        padding: EdgeInsets.all(14.w),
                        child: SvgPicture.asset(
                          widget.prefixSvgPath!,
                          width: 16.w,
                          height: 16.h,
                          colorFilter: ColorFilter.mode(
                            widget.prefixIconColor ??
                                const Color(0xFF9CA3AF),
                            BlendMode.srcIn,
                          ),
                        ),
                      )
                    : null,

                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: widget.suffixIconColor ??
                              const Color(0xFF9CA3AF),
                          size: 20.sp,
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
        ),
      ],
    );
  }
}