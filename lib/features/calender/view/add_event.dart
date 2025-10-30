import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_verse/core/components/custom_input_field.dart';
import 'package:time_verse/core/utils/colors.dart';

class AddEventModal extends StatelessWidget {
  const AddEventModal({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 652.h,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode?Color(0xFF051123):AppColors.text_color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: const Border(top: BorderSide(color: Colors.grey, width: 1.5)),
      ),

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              label: '',
              hintText: 'Enter Name *',
              controller: TextEditingController(),
              isPassword: false,
              fontSize: 12.sp,
              height: 44.h,
              hintFontSize: 12.sp,
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 88.h,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Type the note here...',
                  hintStyle: TextStyle(
                    color:AppColors.text_color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.third_color,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.third_color,
                      width: 1.2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 28.h,
                    horizontal: 16.w,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                cursorColor: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
