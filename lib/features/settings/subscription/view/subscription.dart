import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/core/components/custom_cards.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/settings/subscription/controller/subscription_controller.dart';

class Subscription extends StatelessWidget {
  final SubscriptionController controller;
  const Subscription({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Load offerings once after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadOfferings();
    });

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomHeaderBar(
                title: 'Premium',
                leftSpacing: 90.w,
                rightSpacing: 80.w,
              ),
              SizedBox(height: 20.h),
              Image.asset(
                'assets/images/premium_logo.png',
                width: 144.w,
                height: 144.h,
              ),
              SizedBox(height: 20.h),
              Text(
                'Infini Quote Premium',
                style: GoogleFonts.outfit(
                  fontSize: 20.4.sp,
                  fontWeight: FontWeight.normal,
                  color: isDarkMode
                      ? AppColors.text_color
                      : const Color(0xFF373F4B),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Unlock the full cosmic experience',
                style: GoogleFonts.outfit(
                  fontSize: 11.9.sp,
                  fontWeight: FontWeight.normal,
                  color: isDarkMode
                      ? AppColors.text_color
                      : const Color(0xFF373F4B),
                ),
              ),
              SizedBox(height: 24.h),
              AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  final packages = controller.availablePackages;
                  if (packages.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  debugPrint('*********** Available Packages: ${packages.length} ***********');
                  return Column(
                    children: List.generate(packages.length, (index) {
                      final package = packages[index]; 
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => controller.selectCard(index),
                            child: PhaseCard(
                              title: package.storeProduct.title,
                              subtitle: package.storeProduct.description,
                              isDarkMode: isDarkMode,
                              isSelected: controller.isCardSelected(index),
                              buttonText: index == 0 ? 'Pay Now' : 'Upgrade',
                              onButtonPressed: () async {
                                debugPrint(
                                  'Purchasing package: ${package.storeProduct.title}',
                                );
                                try {
                                  await controller.purchasePackage(package);
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Purchase Successful'),
                                      content: Text(
                                        'You have successfully purchased:\n\n${package.storeProduct.title}',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Purchase Failed'),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              items: [
                                {
                                  'title': '1. App Store Optimization (ASO)',
                                  'details':
                                    '• Monitor download numbers daily\n'
                                    '• Respond to any initial reviews\n'
                                    '• Update screenshots based on feedback',
                                },
                                {
                                  'title': '2. Initial User Support',
                                  'details':
                                    '• Set up a simple support email\n'
                                    '• Create a FAQ section in-app',
                                },
                                {
                                  'title': '3. Basic Analytics',
                                  'details':
                                    '• Track daily active users\n'
                                    '• Monitor API usage\n'
                                    '• Identify crash reports',
                                },
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      );
                    }),
                  );
                },
              ),

              SizedBox(height: 20.h),
              Text(
                'Start 7-Day Free Trial',
                style: GoogleFonts.inter(
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                    ? AppColors.text_color
                    : const Color(0xFF373F4B),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Subscription will automatically renew. Cancel\n anytime.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 10.2.sp,
                  fontWeight: FontWeight.normal,
                  color: isDarkMode
                    ? AppColors.text_color
                    : const Color(0xFF373F4B),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/shield.svg',
                    width: 10.67.w,
                    height: 13.33.h,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Secure Payment Processing',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 10.2.sp,
                      fontWeight: FontWeight.normal,
                      color: isDarkMode
                        ? AppColors.text_color
                        : const Color(0xFF373F4B),
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
