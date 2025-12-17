import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    final profileController = Provider.of<ProfileController>(context, listen: false);
    final baseurl =  dotenv.env['BASE_URL'];
    //!----------- Trigger only once after first build ------------!
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.onInit();
    });

    return Scaffold(
      body: Consumer<ProfileController>(
        builder: (context, controller, child) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
            child: Column(
              children: [
                CustomHeaderBar(
                  title: 'Profile',
                  leftSpacing: 100.w,
                  rightSpacing: 83.w,
                ),
                SizedBox(height: 20.h),
                if (controller.isLoading)
                  const CircularProgressIndicator()
                else ...[
                  // ProfileImagePicker(
                  //   assetPath: 'assets/images/profile_img.png',
                  //   pickedImage: controller.pickedImage,
                  //   onCameraTap: controller.pickImage,
                  // ),
                  ProfileImagePicker(
                    assetPath: 'assets/images/profile_img.png',
                    pickedImage: controller.pickedImage,
                    imageUrl: controller.currentUser?.profilePicture != null
                      ? '$baseurl${controller.currentUser!.profilePicture}'
                      : null,
                    onCameraTap: controller.pickImage,
                  ),
                  SizedBox(height: 20.h),
                  CustomInputField(
                    label: 'Name',
                    hintText: 'Enter your name',
                    controller: controller.nameController,
                    isPassword: false,
                    fontSize: 16.sp,
                    height: 44.h,
                    hintFontSize: 14.sp,
                  ),
                  SizedBox(height: 20.h),
                  CustomInputField(
                    label: 'Email',
                    hintText: 'example@mail.com',
                    controller: controller.emailController,
                    isPassword: false,
                    fontSize: 16.sp,
                    height: 44.h,
                    hintFontSize: 14.sp,
                  ),
                  SizedBox(height: 20.h),
                  DateField(
                    label: 'Date of Birth',
                    selectedDate: DateTime.tryParse(controller.dateController.text) ??
                    DateTime(1995, 5, 23),
                    onDateSelected: (newDate) {},
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    text: "Update",
                    onPressed: () {
                      controller.updateProfile(context);
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
              ],
            ),
          );
        },
      ),
    );
  }
}
