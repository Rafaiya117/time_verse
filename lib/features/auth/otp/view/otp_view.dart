import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_dialogue.dart';
import 'package:time_verse/core/components/custom_otp_field.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/auth/otp/controller/otp_controller.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final otpController = Provider.of<OtpController>(context, listen: false);
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
                'assets/images/otp.png',
                width:219.w,
                height: 219.h,
              ),
            ),
            SizedBox(height: 20.h,),
            Center(
              child: Text(
                'Verification Code',
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
                'We have send OTP verifcation code to your email',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode?AppColors.text_color: AppColors.heading_color    ,
                ),
              ),
            ),
            SizedBox(height: 21.h,),
            Center(
              child: Text(
                'exampl@gmail.com',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode?AppColors.text_color: AppColors.heading_color    ,
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            // CircularOtpField(
            //   onSubmit: (code) {
            //     print('OTP entered: $code');
            //   },
            // ),
            CircularOtpField(
              mainController: otpController.otpController,
              onSubmit: (code) {
                print('OTP entered: $code');
              },
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 128,
                  child: Divider(
                    color: isDarkMode ? AppColors.text_color: AppColors.heading_color,
                    thickness: 1,
                  ),
                ),
                Text(
                  '02.49',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: const Color(0xFFF29F0D),
                  ),
                ),
                SizedBox(
                  width: 128,
                  child: Divider(
                    color: isDarkMode ? AppColors.text_color: AppColors.heading_color,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Center(
              child: CustomButton(
                text: "Continue",
                onPressed: () async {
                  final email = Uri.decodeComponent(
                    GoRouterState.of(context).uri.queryParameters['email'] ?? '',
                  );
                  final controller = Provider.of<OtpController>(
                    context,
                    listen: false,
                  );
                  final otp = controller.otpController.text.replaceAll(
                    RegExp(r'\s+'),'',
                  );
                  debugPrint("Entered OTP: $otp");

                  if (otp.length != 4) {
                    if (context.mounted) {
                      await showErrorDialog(
                        context,
                        'Please enter a 4-digit OTP',
                      );
                    }
                    return;
                  }
                  final isVerified = await controller.verifyOtpUser(email, otp);
                  if (isVerified) {
                    final encodedEmail = Uri.encodeComponent(email);
                    final encodedOtp = Uri.encodeComponent(otp);
                    context.push('/reset_password?email=$encodedEmail&otp=$encodedOtp',);
                  } else {
                    if (context.mounted) {
                      await showErrorDialog(
                        context,
                        controller.otpError ?? 'OTP verification failed',
                      );
                    }
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
            SizedBox(height: 70.h,),
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
                          color: AppColors.fourth_color,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.fourth_color,
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