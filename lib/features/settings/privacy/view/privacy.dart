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
                          color: isDarkMode
                            ? AppColors.text_color
                            : const Color(0xFF373F4B),
                          ),
                          children: [
                            TextSpan(
                              text: controller.privacyData!['description'] ?? '',
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
      ),
    );
  }
}