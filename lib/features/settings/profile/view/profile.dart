import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/components/custom_input_field.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/settings/profile/controller/profile_controller.dart';
import 'package:time_verse/features/settings/profile/custom_widget/custom_datefield.dart';
import 'package:time_verse/features/settings/profile/custom_widget/custom_profileimg_container.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final profile_controller = Provider.of<ProfileController>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 32.h),
        child: Column(
          children: [
            CustomHeaderBar(
              title: 'Profile',
              leftSpacing: 100.w,
              rightSpacing: 83.w,
            ),
            SizedBox(height: 20.h,),
            ProfileImagePicker(
              assetPath: 'assets/images/profile_img.png',
              pickedImage: profile_controller.pickedImage,
              onCameraTap: () {
                profile_controller.pickImage();
              },
            ),
            SizedBox(height: 20.h,),
            CustomInputField(
              label: 'Name',
              hintText: 'Melissa Peters',
              controller: profile_controller.nameController,
              isPassword: false,
              fontSize: 16.sp,
              height: 44.h,
              hintFontSize: 14.sp,
            ),
            SizedBox(height: 20.h,),
            CustomInputField(
              label: 'Email',
              hintText: 'melissapetrs@gmail.com',
              controller: profile_controller.emailController,
              isPassword: false,
              fontSize: 16.sp,
              height: 44.h,
              hintFontSize: 14.sp,
            ),
            SizedBox(height: 20.h,),
            CustomInputField(
              label: 'Passowrd',
              hintText: '********',
              controller: profile_controller.emailController,
              isPassword: true,
              fontSize: 16.sp,
              height: 44.h,
              hintFontSize: 14.sp,
            ),
            SizedBox(height: 20.h,),
            DateField(
              label: 'Date of Birth',
              selectedDate: DateTime(1995, 5, 23),
              onDateSelected: (newDate) {},
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