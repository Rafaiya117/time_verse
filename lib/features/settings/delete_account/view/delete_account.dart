import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/config/app_route/app_prefernce.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_dialogue.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:time_verse/features/home/controller/home_controller.dart';
import 'package:time_verse/features/settings/delete_account/controller/delete_ac_controller.dart';
import 'package:time_verse/features/settings/profile/controller/profile_controller.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
        child: Column(
          children: [
            CustomHeaderBar(
              title: 'Delete Account',
              leftSpacing: 60.w,
              rightSpacing: 55.w,
            ),
            SizedBox(height: 50.h,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF0B1528)
                    : Colors.white, // Dark background canvas match
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isDarkMode
                      ? const Color(0xFFFFB703).withOpacity(
                          0.2,
                        ) // Subtle gold outline accent frame ring
                      : const Color(0xFFE5E7EB),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Vector Asset Layer
                  SvgPicture.asset(
                    isDarkMode
                        ? 'assets/icons/delete_logo.svg'
                        : 'assets/icons/delete_logo_light.svg',
                    width: 90
                        .w, // Scaled cleanly to match image mockup proportion rules
                    height: 90.h,
                  ),
                  SizedBox(height: 24.h),

                  // 2. Section Component Headline
                  Text(
                    'Delete Account',
                    style: GoogleFonts.outfit(
                      fontSize: 24.sp,
                      fontWeight:
                          FontWeight.w700, // Strong prominent weight match
                      color: isDarkMode
                          ? Colors.white
                          : const Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // 3. Informational Message Block
                  Text(
                    'Are you sure you want to delete your account? This action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: isDarkMode
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF4B5563),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // 4. Critical Alert Frame Element Block
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB703).withOpacity(
                        0.06,
                      ), // Translucent premium warning container amber tint fill
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: const Color(0xFFFFB703).withOpacity(0.25),
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: SvgPicture.asset(
                            'assets/icons/warning.svg',
                            width: 18.w,
                            height: 18.h,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFFFB703),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            'Warning: Deleting your account will permanently remove all your data, including your children\'s profiles, events, group memberships, and chat history. This action cannot be undone.',
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              color: const Color(
                                0xFFFFB703,
                              ), // Matching matching gold-orange warning output color properties
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // 5. Destructive Danger Confirmation Trigger Button
                  Consumer<DeleteAcController>(
                    builder: (context, controller, _) {
                      return CustomButton(
                        text: "Delete",
                        onPressed: () async {
                          final password = await showPasswordDialog(context);
                          if (password == null || password.isEmpty) return;

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          final success = await controller.deleteAccount(password,);
                          Navigator.pop(context); // close loader
                          if (success) {
                            await showMessageDialog(
                              context,
                              'Your account has been permanently deleted.',
                              title: 'Success',
                              icon: Icons.check_circle_outline,
                              iconColor: Colors.green,
                            );
                            await Alarm.stopAll();
                            await AppPrefs.setLoggedIn(false);
                            await AuthService().clearToken();
                            context.read<HomeController>().todaysEvents.clear();
                            context.read<ProfileController>().clearProfile();

                            await Future.delayed(const Duration(milliseconds: 800),
                            );
                            if (context.mounted) {
                              Navigator.pop(context);
                              context.go('/login');
                            }
                          } else {
                            await showMessageDialog(
                              context,
                              'Failed to delete account. Check password.',
                              title: 'Error',
                              icon: Icons.error_outline,
                              iconColor: Colors.red,
                            );
                          }
                        },
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFBA1A1A),
                            Color(0xFF7A0000),
                          ], // Crimson/Dark Red profile warning colors
                        ),
                        textColor: Colors.white,
                        fontFamily: 'outfit',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        height: 50.h,
                        width: double.infinity,
                      );
                    },
                  ),
                  SizedBox(height: 14.h),
                  // 6. Action Abort/Cancel Overlay Layer Frame Component
                  CustomButton(
                    text: "Cancel",
                    onPressed: () => Navigator.pop(context),
                    borderGradient: AppGradientColors.button_gradient,
                    solidColor: isDarkMode
                    ? const Color(0xFF0B1528)
                    : Colors.white,
                    textColor: const Color(0xFFFFB703),
                    fontFamily: 'outfit',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    height: 50.h,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ],
        ), 
      ),
    );
  }

  Future<String?> showPasswordDialog(BuildContext context) async {
    final controller = TextEditingController();

    return await showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Enter your password"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;
                Navigator.pop(context, controller.text.trim());
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
