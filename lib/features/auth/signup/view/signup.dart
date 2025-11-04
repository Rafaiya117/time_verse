import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_image_uploader.dart';
import 'package:time_verse/core/components/custom_input_field.dart';
import 'package:time_verse/core/components/prograss_bar.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/auth/signup/controller/signup_controller.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final signup_controller = Provider.of<SignupController>(context, listen: false);
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
                'Dynamic Social Calendar',
                style: GoogleFonts.outfit(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: secondaryTextColor    ,
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            CustomInputField(
              label: 'First Name *',
              hintText: 'Enter your fullname',
              controller: signup_controller.nameController,
              isPassword: false,
              fontSize: 12,
            ),
            SizedBox(height: 20.h,),
            CustomInputField(
              label: 'Email Address *',
              hintText: 'Enter your email...',
              controller: signup_controller.emailController,
              isPassword: false,
              fontSize: 12,
            ),
            SizedBox(height: 20.h,),
            Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    label: 'Password *',
                    hintText: 'Enter your password...',
                    controller: signup_controller.passwordController,
                    isPassword: true,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: CustomInputField(
                    label: 'Confirm Password *',
                    hintText: 'Enter confirm password...',
                    controller: signup_controller.confirm_passwordController,
                    isPassword: true,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
            Consumer<SignupController>(
              builder: (context, controller, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImagePickerBox(
                    svgAsset: 'assets/icons/singup_camera.svg',
                    onTap: controller.pickImage,
                  ),
                  if (controller.pickedImagePath != null)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8,),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        controller.pickedImagePath!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h,),
            Center(
              child: CustomButton(
                text: "Continue",
                onPressed: ()async {
                  //context.push('/login');
                  if (signup_controller.validateSignupFields()) {
                    final success = await signup_controller.signupUser();
                      if (success) {
                        if (context.mounted) context.push('/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              signup_controller.signupError ?? 'Signup failed',
                            ),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill in all fields"),
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
                        text: 'Login',
                        style: GoogleFonts.outfit(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.normal,
                          color: isDarkMode
                            ? AppColors.third_color
                            : AppColors.heading_color,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          context.push('/login');
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