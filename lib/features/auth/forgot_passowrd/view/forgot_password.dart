import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_dialogue.dart';
import 'package:time_verse/core/components/custom_input_field.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/auth/forgot_passowrd/controller/forgot_password_controller.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final forgotpasswordController = Provider.of<ForgotPasswordController>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color secondaryTextColor = isDarkMode 
      ? AppColors.fourth_color 
      : AppColors.heading_color;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:Padding(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 40),
        child: SingleChildScrollView(
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
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Main Title Header
                    Text(
                      'FORGOT PASSWORD',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 26.sp, // Sized prominently to match layout proportions
                        fontWeight: FontWeight.bold,
                        color: AppColors.fourth_color, 
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 10.h,), // Tight dynamic spacing layout matched to image
                    // Subtitle Description Line
                    Text(
                      'We have send OTP code abc abc',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(
                          0xFF9EACBA,
                        ), // Soft slate/grey accent color
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(24.sp),
                decoration: BoxDecoration(
                  color: isDarkMode?AppColors.containers_bgd: AppColors.container,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDarkMode?AppColors.fourth_color: AppColors.new_clr,
                    width:0.5,
                  ),
                ),
                child: Column(
                  children: [
                    CustomInputField(
                      label: 'Email Address *',
                      hintText: 'Enter your email address ...',
                      controller: forgotpasswordController.emailController,
                      isPassword: false,
                      fontSize: 13.sp,
                    ),
                    SizedBox(height: 20.h,),
                    Center(
                      child: CustomButton(
                        text: "Send",
                        onPressed: () async {
                          if (forgotpasswordController.validateLoginFields()) {
                            final success = await forgotpasswordController.sendForgotPasswordEmail();
                            if (success) {
                              if (context.mounted) {
                                final email = forgotpasswordController.emailController
                                  .text.trim();
                                final encodedEmail = Uri.encodeComponent(email);
                                context.push('/otp?email=$encodedEmail');
                              }
                            } else {
                              if (context.mounted) {
                                await showMessageDialog(
                                  context,
                                  forgotpasswordController.errorMessage ?? 'Request failed',
                                );
                              }
                            }
                          } else {
                            if (context.mounted) {
                              await showMessageDialog(context, 'Please enter your email');
                            }
                          }
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
              SizedBox(height: 250.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.normal,
                        fontSize: 13.sp,
                        color: isDarkMode
                          ? AppColors.text_color
                          : AppColors.heading_color,
                        ),
                        children: [
                        const TextSpan(text: 'Don\'t have an account? '),
                        TextSpan(
                          text: 'Sign Up',
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.normal,
                            color: isDarkMode
                              ? AppColors.third_color
                              : AppColors.heading_color,
                            ),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            context.push('/signup');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ) ,
    );
  }
}