import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/settings/terms_condition/controller/terms_controller.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<TermsController>(context, listen: false);
      controller.loadTerms();
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: Column(
            children: [
              CustomHeaderBar(
                title: 'Terms & Condition',
                leftSpacing: 60.w,
                rightSpacing: 40.w,
              ),
              SizedBox(height: 20.h),
              Consumer<TermsController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  return Padding(
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
                            text: 'Clause \n\n',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                               color: isDarkMode
                                ? AppColors.text_color
                                : const Color(0xFF373F4B),
                            ),
                          ),
                          TextSpan(
                            text: controller.description.isNotEmpty
                              ? controller.description
                              : 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.\n\n',
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: [
                  Consumer<TermsController>(
                  builder: (context, controller, _) {
                    return Checkbox(
                      value: controller.isChecked,
                      onChanged: controller.toggleCheckbox,
                      activeColor: AppColors.third_color,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                   );
                  },
                ),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.normal,
                      fontSize: 14.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.text_color
                        : AppColors.heading_color,
                      ),
                      children: [
                        const TextSpan(text: 'I agree to '),
                        TextSpan(
                          text: 'Terms & Condition',
                          style: TextStyle(color: AppColors.fourth_color),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy\n Policy',
                          style: TextStyle(color: AppColors.fourth_color),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}