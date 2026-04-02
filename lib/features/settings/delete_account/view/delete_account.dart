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
            SvgPicture.asset(
              isDarkMode?'assets/icons/delete_logo.svg':'assets/icons/delete_logo_light.svg',
              width: 60.w,
              height: 60.h,
            ),
            SizedBox(height: 20.h,),
            Text(
              'Delete Account',
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
                color: isDarkMode?AppColors.text_color:Color(0xFF373F4B),
              ),
            ),
            SizedBox(height: 20.h,),
            Text(
              'Are you sure you want to delete\n your account?This action can not\n be undone',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
                color: isDarkMode?AppColors.text_color:Color(0xFF373F4B),
              ),
            ),
            SizedBox(height: 20.h,),
            Container(
              width: double.infinity,
              height: 135.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDarkMode?AppColors.containers_bgd:AppColors.text_color,
              ),
              child: Center(
                child: Container(
                  width: 320.w,
                  height: 95.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.fourth_color,
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    // ignore: deprecated_member_use
                    color: Color(0xFFFFE082).withOpacity(0.5),
                  ),
                  child: 
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/warning.svg',
                            width: 19.06.w,
                            height: 17.01.h,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Warning: Deleting your account will permanently remove all your data, including your childrens profiles, events, group memberships, and chat history. This action cannot be undone.',
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                                color: isDarkMode
                                  ? AppColors.text_color
                                  : const Color(0xFF373F4B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            Consumer<DeleteAcController>(
              builder: (context, controller, _) {
                return Center(
                  child: CustomButton(
                    text: "Delete",
                    onPressed: () async {
                      // 🔐 Ask password
                      final password = await showPasswordDialog(context);
                      if (password == null || password.isEmpty) return;

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>const Center(child: CircularProgressIndicator()),
                      );

                      final success = await controller.deleteAccount(password);
                      Navigator.pop(context); // close loader
                      if (success) {
                        await showMessageDialog(
                          context,
                          'Your account has been permanently deleted.',
                          title: 'Success',
                          icon: Icons.check_circle_outline,
                          iconColor: Colors.green,
                        );
                        // 🧹 clear session
                        await Alarm.stopAll();
                        await AppPrefs.setLoggedIn(false);
                        await AuthService().clearToken();
                        context.read<HomeController>().todaysEvents.clear();
                        context.read<ProfileController>().clearProfile();

                        await Future.delayed(const Duration(milliseconds: 800));
                        if (context.mounted) {
                          Navigator.pop(context); // close loader
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
                    gradient: AppGradientColors.button_gradient,
                    textColor: AppColors.text_color,
                    fontFamily: 'outfit',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    height: 51.h,
                    width: double.infinity,
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),
            Center(
              child: CustomButton(
                text: "Cancel",
                onPressed: () {},
                borderGradient: AppGradientColors.button_gradient,
                solidColor: isDarkMode?AppColors.containers_bgd:AppColors.background_color,
                textColor: AppColors.third_color,
                fontFamily: 'outfit',
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                height: 51.h,
                width: double.infinity,
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
