import 'package:flutter/material.dart' hide DatePickerDialog;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_input_field.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/calender/controller/time_controller.dart';
import 'package:time_verse/features/calender/widget/custom_chip.dart';
import 'package:time_verse/features/calender/widget/custom_date_picker.dart';
import 'package:time_verse/features/calender/widget/time_picker_custom_widget.dart';

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
            Align(
              alignment: Alignment.center,
              child: Text(
                'Add Event',
                style: GoogleFonts.outfit(
                  color: isDarkMode?AppColors.third_color:AppColors.heading_color,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 16.h),
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
                    color:isDarkMode?AppColors.text_color:AppColors.heading_color,
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
            SizedBox(height:16.h),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (_) => const DatePickerDialog(),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color:AppColors.fourth_color),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Text("Date", style: GoogleFonts.outfit(color: isDarkMode?AppColors.text_color:AppColors.heading_color)),
                    Icon(Icons.calendar_today, color: isDarkMode?AppColors.text_color:AppColors.heading_color),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<TimePickerController>(
                  builder: (context, controller, _) => TimePickerField(
                    fieldKey: 'start',
                    label: 'Start Time',
                    icon: Icons.access_time,
                  ),
                ),
                Consumer<TimePickerController>(
                builder: (context, controller, _) => TimePickerField(
                  fieldKey: 'end',
                  label: 'End Time',
                  icon: Icons.access_time,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h,),
            CustomInputField(
              label: '',
              hintText: 'Enter Address *',
              controller: TextEditingController(),
              isPassword: false,
              fontSize: 12.sp,
              height: 44.h,
              hintFontSize: 12.sp,
            ),
            SizedBox(height: 16.h,),
            Consumer<TimePickerController>(
              builder: (context, controller, _) => TimePickerField(
                fieldKey: 'alarm',
                label: 'Alarm',
                icon: 'assets/icons/alarm.svg', 
              ),
            ),
            SizedBox(height: 16.h,),
             Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Category',
                style: GoogleFonts.outfit(
                  color: isDarkMode?AppColors.third_color:AppColors.heading_color,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 16.h,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  BulletButton(
                    label: 'Brainstorm',
                    color: AppColors.fourth_color,
                    iconPath: 'assets/icons/bullet_point.svg',
                  ),
                  SizedBox(width: 16.w),
                  BulletButton(
                    label: 'Design',
                    color: AppColors.fifth_color,
                    iconPath: 'assets/icons/bullet_point.svg',
                  ),
                  SizedBox(width: 16.w),
                  BulletButton(
                    label: 'Work',
                    color: AppColors.fourth_color,
                    iconPath: 'assets/icons/bullet_point.svg',
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h,),
            CustomButton(
              text: "Save",
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Saved successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pop(context);
                });
              },
                gradient: AppGradientColors.button_gradient,
                textColor: AppColors.text_color,
                fontFamily: 'outfit',
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                height: 51.h,
                width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
