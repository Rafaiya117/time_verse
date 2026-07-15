import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      otpController.startTimer();
    });
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        // Wrapped the Column in a SingleChildScrollView to eliminate vertical overflow
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/forgot_password.png',
                  width: 219.w,
                  height: 219.h,
                ),
              ),
              SizedBox(height: 5.h,),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'VERIFICATION CODE',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 26.sp, 
                        fontWeight: FontWeight.bold,
                        color: AppColors.fourth_color,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 12.h,), 
                    Text(
                      'We have sand OTP code verification\nto your email',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9EACBA,), 
                        height: 1.4, 
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.containers_bgd
                      : AppColors.container,
                  borderRadius: BorderRadius.circular(
                    16,
                  ), // Increased radius to match the image
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.fourth_color
                        : AppColors.new_clr,
                    width: 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    CircularOtpField(
                      mainController: otpController.otpController,
                      onSubmit: (code) {
                        print('OTP entered: $code');
                      },
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        // Using Expanded allows dividers to stretch to edges perfectly like the image
                        Expanded(
                          child: Divider(
                            color: isDarkMode
                                ? AppColors.text_color.withOpacity(0.3)
                                : AppColors.heading_color.withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Consumer<OtpController>(
                            builder: (context, controller, _) {
                              return Text(
                                controller.formattedTime,
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                  color: const Color(0xFFF29F0D),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: isDarkMode
                                ? AppColors.text_color.withOpacity(0.3)
                                : AppColors.heading_color.withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Center(
                      child: Container(
                        // Mimics the clean bottom glow effect beneath the button
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF29F0D).withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: CustomButton(
                          text: "Recover Account",
                          onPressed: () async {
                            final email = Uri.decodeComponent(
                              GoRouterState.of(
                                    context,
                                  ).uri.queryParameters['email'] ??
                                  '',
                            );
                            final controller = Provider.of<OtpController>(
                              context,
                              listen: false,
                            );
                            final otp = controller.otpController.text
                                .replaceAll(RegExp(r'\s+'), '');
                            debugPrint("Entered OTP: $otp");

                            if (otp.length != 4) {
                              if (context.mounted) {
                                await showMessageDialog(
                                  context,
                                  'Please enter a 4-digit OTP',
                                );
                              }
                              return;
                            }
                            final isVerified = await controller.verifyOtpUser(
                              email,
                              otp,
                            );
                            if (isVerified) {
                              final encodedEmail = Uri.encodeComponent(email);
                              final encodedOtp = Uri.encodeComponent(otp);
                              context.push(
                                '/reset_password?email=$encodedEmail&otp=$encodedOtp',
                              );
                            } else {
                              if (context.mounted) {
                                await showMessageDialog(
                                  context,
                                  controller.otpError ??
                                      'OTP verification failed',
                                );
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: isDarkMode
                          ? AppColors.text_color
                          : const Color(0xFFC2C2C2),
                      ),
                      children: [
                        const TextSpan(text: 'Did not recive OTP code? '),
                        TextSpan(
                          text: 'Resend',
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.fourth_color,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.fourth_color,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            context.push('/forgot_pass');
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
      ),
    );
  }
}