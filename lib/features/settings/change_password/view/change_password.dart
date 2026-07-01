import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/components/custom_input_field.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/settings/change_password/controller/changepassowrd_controller.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final changepassowrdController = Provider.of<ChangepassowrdController>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 32.h),
          child: Column(
            children: [
              CustomHeaderBar(
                title: 'Change Password',
                leftSpacing: 60.w,
                rightSpacing: 30.w,
              ),
              SizedBox(height: 20.h,),
              Container(
                padding: EdgeInsets.all(16.w,), 
                decoration: BoxDecoration(
                  color: isDarkMode
                  ? const Color(0xFF0B1528)
                  : Colors.white, 
                  borderRadius: BorderRadius.circular(16.r,), 
                  border: Border.all(
                    color: isDarkMode
                    // ignore: deprecated_member_use
                    ? const Color(0xFFFFB703).withOpacity(0.2,) // Amber luxury thin line border
                    : const Color(0xFFE5E7EB),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Text(
                      'Old Password',
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                        ? Colors.white
                        : const Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomInputField(
                      label: '',
                      hintText:'***********', 
                      controller: changepassowrdController.old_passwordController,
                      isPassword: true,
                      fontSize: 16.sp,
                      height: 52.h, 
                      hintFontSize: 16.sp,
                      //prefixSvgPath: 'assets/icons/lock_icon.svg',
                      // prefixIconColor: isDarkMode
                      //     ? const Color(0xFFFFB703)
                      //     : const Color(0xFF353535),
                      suffixIconColor: Colors.white,
                    ),
                    SizedBox(height: 18.h),
        
                    // 2. New Password Section
                    Text(
                      'New Password',
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                        ? Colors.white
                        : const Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomInputField(
                      label: '',
                      hintText: '***********',
                      controller: changepassowrdController.new_passwordController,
                      isPassword: true,
                      fontSize: 16.sp,
                      height: 52.h,
                      hintFontSize: 16.sp,
                      // prefixSvgPath: 'assets/icons/lock_icon.svg',
                      // prefixIconColor: isDarkMode
                      // ? const Color(0xFFFFB703)
                      // : const Color(0xFF353535),
                      suffixIconColor: Colors.white,
                    ),
                    SizedBox(height: 18.h),
                    // 3. Confirm Password Section
                    Text(
                      'Confirm Password',
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                        ? Colors.white
                        : const Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomInputField(
                      label: '',
                      hintText: '***********',
                      controller:changepassowrdController.confirm_passwordController,
                      isPassword: true,
                      fontSize: 16.sp,
                      height: 52.h,
                      hintFontSize: 16.sp,
                      // prefixSvgPath: 'assets/icons/lock_icon.svg',
                      // prefixIconColor: isDarkMode
                      // ? const Color(0xFFFFB703)
                      // : const Color(0xFF353535),
                      suffixIconColor: Colors.white,
                    ),
                    SizedBox(height: 24.h),
                    // Action Submission Button Layer
                    CustomButton(
                      text: "Update",
                      onPressed: () {
                        changepassowrdController.changePassword(context);
                      },
                      gradient: AppGradientColors.button_gradient,
                      textColor: Colors.black,
                      fontFamily: 'outfit',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      height: 50.h,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}