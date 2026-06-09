import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/settings/privacy/controller/privacy_policy_controller.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PrivacyController>(context, listen: true);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.privacyData == null && !controller.isLoading) {
        controller.loadPrivacyPolicy();
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: Column(
            children: [
              CustomHeaderBar(
                title: 'Privacy Policy',
                leftSpacing: 60.w,
                rightSpacing: 60.w,
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF0B1528) : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 22.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Shield Outline Icon
                      Icon(
                        Icons.gpp_good_outlined,
                        color: const Color(0xFFFFB703), // Gold tone
                        size: 54.sp,
                      ),
                      SizedBox(width: 18.w),
                      // Text Layout Stack
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Privacy, Our Priority', // Title text
                              style: GoogleFonts.outfit(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFFB703),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'We are committed to protecting your trust and personal information.', // Description text
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.35,
                                color: isDarkMode
                                ? const Color(0xFFE5E7EB)
                                : const Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF0B1528) : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDarkMode? const Color(0xFFFFB703).withOpacity(0.2): const Color(0xFFE5E7EB),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.isLoading)
                    const Center(child: CircularProgressIndicator())
                    else if (controller.errorMessage != null)
                      Text(
                        controller.errorMessage!,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          color: Colors.red,
                        ),
                      )
                    else if (controller.privacyData != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                                color: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B),
                              ),
                              children: [
                                TextSpan(
                                  text: (controller.privacyData!['description'] ?? '').replaceAll(RegExp(r'<[^>]*>'), '') // Removes tags like <p>, </p>, etc..trim(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      Text(
                        'No privacy policy available.',
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          color: isDarkMode
                          ? AppColors.text_color
                          : const Color(0xFF373F4B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}