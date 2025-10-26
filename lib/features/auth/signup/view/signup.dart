import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_input_field.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/auth/signup/controller/signup_controller.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Provider.of<SignupController>(context, listen: false);
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
              label: 'First Name*',
              hintText: 'Enter name',
              controller: loginController.nameController,
              isPassword: false,
              fontSize: 12,
            )
          ],
        ),
      ) ,
    );
  }
}