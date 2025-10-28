import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:time_verse/core/utils/colors.dart';

class ProfileImagePicker extends StatelessWidget {
  final String assetPath;
  final File? pickedImage; // ✅ added
  final VoidCallback onCameraTap;

  const ProfileImagePicker({
    super.key,
    required this.assetPath,
    required this.onCameraTap,
    this.pickedImage, // ✅ added
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 120.w,
      height: 120.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDarkMode
                    ? AppColors.text_color
                    : const Color(0xFFC2C2C2),
                width: 1.5,
              ),
            ),
            child: Container(
              width: 165.94.w,
              height: 170.3.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: pickedImage != null
                      ? FileImage(pickedImage!)
                      : AssetImage(assetPath) as ImageProvider, // ✅ updated
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10.h,
            right: -4.w,
            child: GestureDetector(
              onTap: onCameraTap,
              child: Container(
                width: 32.w,
                height: 32.w,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/camera.svg',
                    width: 26.67.w,
                    height: 24.h,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
