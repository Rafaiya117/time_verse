import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_input_field.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/settings/change_password/controller/changepassowrd_controller.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final changepassowrd_controller = Provider.of<ChangepassowrdController>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 32.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: (){
                    context.pop();
                  }, 
                  icon: SvgPicture.asset(
                    'assets/icons/arrow_back.svg',
                    width: 17.5.w,
                    height: 15.01.h,
                    // ignore: deprecated_member_use
                    color: isDarkMode?AppColors.text_color:AppColors.heading_color,
                  ),
                ),
                SizedBox(width: 60.w,),
                Text(
                  'Change Password',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: isDarkMode? AppColors.text_color: AppColors.heading_color,
                  ),
                ),
                SizedBox(width: 40.w,),
                IconButton(
                  onPressed: (){
                    themeProvider.toggleTheme();
                  }, 
                  icon: SvgPicture.asset(
                    isDarkMode?'assets/icons/theme_dark.svg':'assets/icons/light_theme.svg',
                    width: 15.w,
                    height: 15.h,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
            CustomInputField(
              label: '',
              hintText: 'Old Password',
              controller: changepassowrd_controller.old_passwordController,
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
              controller: changepassowrd_controller.new_passwordController,
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
              controller: changepassowrd_controller.confirm_passwordController,
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
                //context.push('/login');
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