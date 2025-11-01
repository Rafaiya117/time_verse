import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_input_field.dart';
import 'package:time_verse/core/components/prograss_bar.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/auth/login/controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Provider.of<LoginController>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String logoAsset = isDarkMode
      ? 'assets/images/logo.png' 
      : 'assets/images/logo_light.png';
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
                logoAsset,
                width:124.w,
                height: 124.h,
              ),
            ),
            SizedBox(height: 20.h,),
            Center(
              child: Text(
                'Welcome Back',
                style: GoogleFonts.outfit(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: secondaryTextColor    ,
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            Center(
              child: Text(
                'Sign in to continue organizing amazing activities',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode?AppColors.text_color: AppColors.heading_color    ,
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            CustomInputField(
              label: 'Email Address *',
              hintText: 'Enter your email...',
              controller: loginController.emailController,
              isPassword: false,
              fontSize: 12,
            ),
            SizedBox(height: 30.h,),
            CustomInputField(
              label: 'Password *',
              hintText: 'Enter your password...',
              controller: loginController.passwordController,
              isPassword: true,
              fontSize: 12,
            ),
            SizedBox(height: 20.h,),
            Consumer<LoginController>(
              builder: (context, controller, _) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: controller.rememberMe,
                        onChanged: controller.toggleRememberMe,
                        activeColor: AppColors.third_color,
                        materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text(
                        'Remember me',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color:Theme.of(context).brightness == Brightness.dark
                            ? AppColors.text_color
                            :AppColors.heading_color,
                            ),
                          ),
                          SizedBox(width: 123.w,),
                          //Spacer(),
                          TextButton(
                            onPressed: (){
                              context.push('/forgot_pass');
                            },
                            child: Text(
                              'Forgot Password',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 10.sp,
                                color: AppColors.third_color,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.third_color 
                            ),
                          ), 
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20.h,),
            Center(
              child: CustomButton(
                text: "Continue",
                onPressed: () {
                  //context.push('/signup');
                  context.push('/home');
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
            SizedBox(height: 20.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.normal,
                      fontSize: 10.sp,
                      color: isDarkMode
                        ? AppColors.text_color
                        : AppColors.heading_color,
                      ),
                      children: [
                      const TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Sign Up',
                        style: GoogleFonts.outfit(
                          fontSize: 10.sp,
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
            SizedBox(height: 30.h,),
            Center(
              child: GestureDetector(
                onTap: () {
                  
                },
                child: SvgPicture.asset(
                  'assets/icons/gmail.svg',
                  width: 35.w,
                  height: 35.h,
                ),
              ),
            ),
            SizedBox(height: 120.h,),
            Center(
              child: SizedBox(
                width: 142.w,
                child: ProgressIndicatorWidget(
                  barHeight: 4,
                  percentage: 100,
                  progressColor: AppColors.third_color,
                ),
              ),
            ),
          ],
        ),
      ) ,
    );
  }
}