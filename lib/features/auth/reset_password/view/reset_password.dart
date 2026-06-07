import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_input_field.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/auth/reset_password/controller/reset_password_controller.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final resetpasswordController = Provider.of<ResetPasswordController>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final routerState = GoRouterState.of(context);
    final email = Uri.decodeComponent(routerState.uri.queryParameters['email'] ?? '');
    final otp = Uri.decodeComponent(routerState.uri.queryParameters['otp'] ?? '');
    final Color secondaryTextColor = isDarkMode 
      ? AppColors.fourth_color 
      : AppColors.heading_color;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:Padding(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 40),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/forgot_password.png',
                width:233.w,
                height: 184.h,
              ),
            ),
            SizedBox(height: 5.h,),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Main Title Header
                Text(
                  'CREATE NEW PASSWORD',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26.sp, 
                    fontWeight: FontWeight.bold,
                    color: AppColors.fourth_color, 
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 14.h,), // Clean vertical spacing between header elements
                // Subtitle Description Lines
                Text(
                  'Create a new password to secure your\naccount and continue safely.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9EACBA,), 
                    height:1.4, 
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
            Container(
              padding: EdgeInsets.all(24.sp),
              decoration: BoxDecoration(
                color: isDarkMode?AppColors.containers_bgd: AppColors.container,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDarkMode?AppColors.fourth_color.withOpacity(0.5): AppColors.new_clr,
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  CustomInputField(
                    label: 'New Password*',
                    hintText: 'Enter your passowrd...',
                    controller: resetpasswordController.passwordController,
                    isPassword: true,
                    fontSize: 13.sp,
                  ),
                  SizedBox(height: 20.h,),
                  CustomInputField(
                    label: 'Confirm Password*',
                    hintText: 'Enter your password...',
                    controller: resetpasswordController.confirm_passwordController,
                    isPassword: true,
                    fontSize: 13.sp,
                  ),
                  SizedBox(height: 20.h,),
                  Center(
                    child: CustomButton(
                      text: "Continue",
                      onPressed: () async{
                        if (resetpasswordController.validateLoginFields()) {
                          final success = await resetpasswordController.resetPassword(email,otp,);
                          if (success) {
                            debugPrint("✅ Password reset success confirmed. Navigating to login...",);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Password reset successful"),
                              ),
                            );
                            await Future.delayed(const Duration(milliseconds: 800));
                            if (context.mounted) {
                              context.go('/login');
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    resetpasswordController.errorMessage ?? 'Reset failed',
                                  ),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please fill all fields")),
                            );
                          }
                        //context.push('/login');
                      },
                      gradient: AppGradientColors.button_gradient,
                      textColor: Colors.black,
                      fontFamily: 'outfit',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      height: 51.h,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ) ,
    );
  }
}