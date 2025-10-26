import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  // Button style options
  final double? width;
  final double? height;
  final double borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? solidColor;
  final LinearGradient? gradient; 
  final EdgeInsetsGeometry? padding;
  final FontStyle? fontStyle;

  // Dynamic Google font
  final String? fontFamily;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.solidColor,
    this.gradient,
    this.padding,
    this.fontStyle,
    this.fontFamily,
  }) : super(key: key);

  TextStyle _buildTextStyle() {
    final baseStyle = TextStyle(
      fontSize: fontSize ?? 14.sp,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: textColor ?? Colors.white,
      fontStyle: fontStyle ?? FontStyle.normal,
    );

    switch (fontFamily?.toLowerCase()) {
      case 'poppins':
        return GoogleFonts.poppins(textStyle: baseStyle);
      case 'lato':
        return GoogleFonts.lato(textStyle: baseStyle);
      case 'roboto':
        return GoogleFonts.roboto(textStyle: baseStyle);
      case 'montserrat':
        return GoogleFonts.montserrat(textStyle: baseStyle);
      case 'nunito':
        return GoogleFonts.nunito(textStyle: baseStyle);
      case 'inter':
      default:
        return GoogleFonts.inter(textStyle: baseStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasGradient = gradient != null; // ✅ fixed check

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 48.h,
        padding: padding ?? EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: hasGradient ? gradient : null,
          color: hasGradient
              ? null
              : (solidColor ?? Theme.of(context).primaryColor),
        ),
        alignment: Alignment.center,
        child: Text(text, style: _buildTextStyle()),
      ),
    );
  }
}
