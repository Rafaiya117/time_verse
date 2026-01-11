import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 32.h),
        child: Column(
          children: [
            CustomHeaderBar(
              title: 'Change Password',
              leftSpacing: 60.w,
              rightSpacing: 30.w,
            ),
            SizedBox(height: 20.h,),
            CustomInputField(
              label: '',
              hintText: 'Old Password',
              controller: changepassowrdController.old_passwordController,
              isPassword: true,
              fontSize: 16.sp,
              height: 44.h,
              hintFontSize: 16.sp,
              prefixSvgPath: 'assets/icons/lock_icon.svg',
              prefixIconColor: isDarkMode? AppColors.fourth_color:Color(0xFF353535),
              suffixIconColor: AppColors.fourth_color,
            ),
            SizedBox(height: 10.h,),
            CustomInputField(
              label: '',
              hintText: 'New Password',
              controller: changepassowrdController.new_passwordController,
              isPassword: true,
              fontSize: 16.sp,
              height: 44.h,
              hintFontSize: 16.sp,
              prefixSvgPath: 'assets/icons/lock_icon.svg',
              prefixIconColor: isDarkMode? AppColors.fourth_color:Color(0xFF353535),
              suffixIconColor: AppColors.fourth_color,
            ),
            SizedBox(height: 10.h,),
            CustomInputField(
              label: '',
              hintText: 'Confirm Password',
              controller: changepassowrdController.confirm_passwordController,
              isPassword: true,
              fontSize: 16.sp,
              height: 44.h,
              hintFontSize: 16.sp,
              prefixSvgPath: 'assets/icons/lock_icon.svg',
              prefixIconColor: isDarkMode? AppColors.fourth_color:Color(0xFF353535),
              suffixIconColor: AppColors.fourth_color,
            ),
            SizedBox(height: 20.h,),
            CustomButton(
              text: "Update",
              onPressed: () {
               changepassowrdController.changePassword(context);
              },
              gradient: AppGradientColors.button_gradient,
              textColor: AppColors.text_color,
              fontFamily: 'outfit',
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              height: 50.h,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}