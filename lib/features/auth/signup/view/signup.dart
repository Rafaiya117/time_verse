// ignore_for_file: deprecated_member_use

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/config/app_route/app_prefernce.dart';
import 'package:time_verse/config/services/google_service.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_dialogue.dart';
import 'package:time_verse/core/components/custom_drop_down.dart';
import 'package:time_verse/core/components/custom_image_uploader.dart';
import 'package:time_verse/core/components/custom_input_field.dart';
import 'package:time_verse/core/components/prograss_bar.dart';
import 'package:time_verse/core/components/social_action_button.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/auth/signup/controller/signup_controller.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class Signup extends StatelessWidget {
  Signup({super.key});
  final ValueNotifier<bool> _isTermsAgreed = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final googleServices = GoogleServices();
    final signupController = Provider.of<SignupController>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String logoAsset = isDarkMode
      ? 'assets/images/logo.png' 
      : 'assets/images/logo_light.png';
      WidgetsBinding.instance.addPostFrameCallback((_) {
      googleServices.init();
    });
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
                  logoAsset,
                  width:124.w,
                  height: 124.h,
                ),
              ),
              SizedBox(height: 10.h,),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Main Title Header
                    Text(
                      'Create your account',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32.sp, 
                        fontWeight: FontWeight.bold,
                        color: isDarkMode? AppColors.third_color: AppColors.new_clr, 
                      ),
                    ),
                    SizedBox(height: 12.h,), 
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                      ), // Ensures clean screen side margins
                      child: Text(
                        'Join InfiniQuote and begin your journey\ntowards wisdom and connection.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9EACBA,), 
                          height:1.5, 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.containers_bgd : AppColors.background_color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:  AppColors.fourth_color ,
                    width: 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomInputField(
                            label: 'First Name *',
                            hintText: 'Enter your first name...',
                            controller: signupController.firstNameController, // Updated controller
                            isPassword: false,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(width: 15.w), // Adjust width as per your design
                        Expanded(
                          child: CustomInputField(
                            label: 'Last Name *',
                            hintText: 'Enter your last name...',
                            controller: signupController.surnameController, // Updated controller
                            isPassword: false,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    CustomInputField(
                      label: 'Email Address *',
                      hintText: 'Enter your email address...',
                      controller: signupController.emailController,
                      isPassword: false,
                      fontSize: 13.sp,
                    ),
                    SizedBox(height: 20.h,),
                    Row(
                      children: [
                        // --- Gender Dropdown ---
                        Expanded(
                          child: CustomDropdownField<String>(
                            label: "Select Gender*",
                            hintText: "Choose one",
                            value: signupController.selectedgender,
                            items: ["Male", "Female", "Other"].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) => signupController.updateGender(newValue),
                          ),
                        ),
                        SizedBox(width: 15.w), // Space between the two dropdowns
                        // --- Nationality Dropdown ---
                        Expanded(
                          child: CustomDropdownField<String>(
                            label: "Nationality*",
                            hintText: "Select",
                            value: signupController.selectedNationality,
                            items: ["American", "British", "Canadian", "Other"].map((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) => signupController.updateNationality(newValue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Column(
                      children: [
                        CustomInputField(
                          label: 'Password *',
                          hintText: 'Enter your password...',
                          controller: signupController.passwordController,
                          isPassword: true,
                          fontSize: 13.sp,
                        ),
                        SizedBox(height: 20.h),
                        CustomInputField(
                          label: 'Confirm Password *',
                          hintText: 'Enter confirm password...',
                          controller: signupController.confirm_passwordController,
                          isPassword: true,
                          fontSize: 13.sp,
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                path.basename(controller.pickedImagePath!),
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
                  ],
                ),
              ),
              
              // 🛠️ CHECKBOX EXTENSION ROW INJECTED HERE
              SizedBox(height: 16.h),
              ValueListenableBuilder<bool>(
                valueListenable: _isTermsAgreed,
                builder: (context, isAgreed, child) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: Checkbox(
                            value: isAgreed,
                            activeColor: AppColors.third_color,
                            checkColor: Colors.black,
                            side: BorderSide(color: AppColors.fourth_color, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            onChanged: (bool? value) {
                              _isTermsAgreed.value = value ?? false; // Updates the listener state cleanly
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                color: isDarkMode ? AppColors.text_color : AppColors.heading_color,
                              ),
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(color: AppColors.third_color, fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    // Handle Terms Navigation Action
                                  },
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(color: AppColors.third_color, fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    // Handle Privacy Policy Navigation Action
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h,),
              Center(
                child: CustomButton(
                  text: "Create  Account",
                  onPressed: () async {
                    if (signupController.validateSignupFields()) {
                      final success = await signupController.signupUser();
                      if (success) {
                        if (context.mounted) context.push('/login');
                      } else {
                        if (context.mounted) {
                          await showMessageDialog(
                            context,
                            signupController.signupError ?? 'Signup failed',
                          );
                        }
                      }
                    } else {
                      if (context.mounted) {
                        await showMessageDialog(
                          context,
                          'Please fill in all fields',
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
              SizedBox(height: 20.h,),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1.5, 
                      margin: EdgeInsets.only(right: 12.w), 
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.0), 
                            Colors.white.withOpacity(0.65), 
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                  // Center Text
                  Text(
                    'Or continue with',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9E9E9E), // Muted grey color matching the image text
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Right divider line
                  Expanded(
                    child: Container(
                      height: 1.5,
                      margin: EdgeInsets.only(left: 12.w), 
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.55,),
                            Colors.white.withOpacity(0.0,), 
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h,),
               Center(
                child: SocialAuthButton(
                  text: 'Sign in with Google',
                  icon: SvgPicture.asset(
                    'assets/icons/gmail.svg',
                    fit: BoxFit.contain,
                  ),
                  onTap: () async {
                    final success = await googleServices.signIn();
                    if (success) {
                      await AppPrefs.setLoggedIn(true);
                      await AppPrefs.setGoogleLogin(
                        false,
                      ); // Retained your new preference flag cleanly
                      await AppPrefs.setFirstLaunch(false);
                      if (context.mounted) context.push('/home');
                    } else {
                      if (context.mounted) {
                        await showMessageDialog(
                          context,
                          "Google Sign-In failed",
                        );
                      }
                    }
                  },
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
                        fontSize: 13.sp,
                        color: isDarkMode
                          ? AppColors.text_color
                          : AppColors.heading_color,
                        ),
                        children: [
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Login',
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
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
            ],
          ),
        ),
      ),
    );
  }
}