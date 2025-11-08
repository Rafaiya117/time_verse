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
                'assets/images/reset_passowrd.png',
                width:233.w,
                height: 184.h,
              ),
            ),
            SizedBox(height: 20.h,),
            Center(
              child: Text(
                'Create New Passowrd',
                style: GoogleFonts.outfit(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  color: secondaryTextColor    ,
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            Center(
              child: Text(
                'We have send otp code abc abc',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode?AppColors.text_color: AppColors.heading_color    ,
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            CustomInputField(
              label: 'New Password*',
              hintText: 'Enter your passowrd...',
              controller: resetpasswordController.passwordController,
              isPassword: true,
              fontSize: 12,
            ),
            SizedBox(height: 20.h,),
            CustomInputField(
              label: 'Confirm Password*',
              hintText: 'Enter your password...',
              controller: resetpasswordController.confirm_passwordController,
              isPassword: true,
              fontSize: 12,
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
                textColor: AppColors.text_color,
                fontFamily: 'outfit',
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                height: 51.h,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ) ,
    );
  }
}