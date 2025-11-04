import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_input_field.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/auth/forgot_passowrd/controller/forgot_password_controller.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final forgotpassword_controller = Provider.of<ForgotPasswordController>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
            SizedBox(height: 20.h,),
            Center(
              child: Text(
                'Forgot Passowrd',
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
              label: 'Email Address *',
              hintText: 'Enter your email...',
              controller: forgotpassword_controller.emailController,
              isPassword: false,
              fontSize: 12,
            ),
            SizedBox(height: 20.h,),
            Center(
              child: CustomButton(
                text: "Recover Account",
                onPressed: ()async {
                  //context.push('/otp');
                  if (forgotpassword_controller.validateLoginFields()) {
                    final success = await forgotpassword_controller.sendForgotPasswordEmail();
                      if (success) {
                        if (context.mounted) {
                          final email = forgotpassword_controller.emailController.text.trim();
                          final encodedEmail = Uri.encodeComponent(email);
                          context.push('/otp?email=$encodedEmail');
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              forgotpassword_controller.errorMessage ??
                                'Request failed',
                            ),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter your email"),
                        ),
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
            ),
            SizedBox(height: 250.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: isDarkMode
                        ? AppColors.text_color
                        : Color(0xFFC2C2C2),
                      ),
                      children: [
                      const TextSpan(text: 'Did not recive OTP code? '),
                      TextSpan(
                        text: 'Resend',
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF543558),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF543558),
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          //context.push('/signup');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),            
          ],
        ),
      ) ,
    );
  }
}