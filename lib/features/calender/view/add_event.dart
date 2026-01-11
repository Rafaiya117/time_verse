import 'package:flutter/material.dart' hide DatePickerDialog;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/config/services/alerm_notification_service.dart';
import 'package:time_verse/config/services/alerm_service.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_dialogue.dart';
import 'package:time_verse/core/components/custom_input_field.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/calender/controller/add_event_controller.dart';
import 'package:time_verse/features/calender/controller/time_controller.dart';
import 'package:time_verse/features/calender/widget/custom_chip.dart';
import 'package:time_verse/features/calender/widget/custom_date_picker.dart';
import 'package:time_verse/features/calender/widget/time_picker_custom_widget.dart';

class AddEventModal extends StatelessWidget {
  const AddEventModal({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final addEventController = Provider.of<AddEventController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addEventController.fetchCategories();
    });
    return Container(
      height: 652.h,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode?Color(0xFF051123):AppColors.text_color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
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
              controller: addEventController.titleController,
              isPassword: false,
              fontSize: 12.sp,
              height: 44.h,
              hintFontSize: 12.sp,
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 88.h,
              child: TextFormField(
                controller: addEventController.noteController,
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
                  color: isDarkMode?AppColors.text_color:AppColors.heading_color,
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
                builder: (_) => DatePickerDialog(
                  controller: addEventController.dateController,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.fourth_color),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: addEventController.dateController,
                      builder: (context, value, child) {
                        return Text(
                          value.text.isEmpty ? "Date" : value.text,
                          style: GoogleFonts.outfit(
                            color: isDarkMode
                                ? AppColors.text_color
                                : AppColors.heading_color,
                          ),
                        );
                      },
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: isDarkMode
                      ? AppColors.text_color
                      : AppColors.heading_color,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
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
              hintText: 'Enter Address',
              controller: addEventController.locationController,
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
              child: 
              Consumer<AddEventController>(
                builder: (context, controller, _) {
                  final categories = controller.categories;
                  if (categories.isEmpty) {
                    return Row(
                      children: List.generate(3, (index) {
                        return Row(
                          children: [
                            BulletButton(
                              label: 'Loading...',
                              color: AppColors.fourth_color,
                              iconPath: 'assets/icons/bullet_point.svg',
                            ),
                            SizedBox(width: 16.w),
                          ],
                        );
                      }),
                    );
                  }
                  return Row(
                    children: List.generate(categories.length, (index) {
                      final category = categories[index];
                      final baseColor = index % 2 == 0 ? AppColors.fourth_color: AppColors.fifth_color;
                      final color = controller.selectedCategory == category.name ? AppColors.heading_color : baseColor;
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              debugPrint('Selected Category: ${category.name}');
                              controller.selectCategory(category.name);
                            },
                            child: BulletButton(
                              label: category.name,
                              color: color,
                              iconPath: 'assets/icons/bullet_point.svg',
                            ),
                          ),
                          SizedBox(width: 16.w),
                        ],
                      );
                    }),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            CustomButton(
              text: "Save",
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>const Center(child: CircularProgressIndicator()),);
                  try {
                  final timeController = Provider.of<TimePickerController>(context,listen: false,);
                  // Format times in HH:mm:ss (backend expects only time)
                  final start = timeController.formatTime(timeController.getTime('start'),);
                  final end = timeController.formatTime(timeController.getTime('end'),);
                  final alarm = timeController.formatTime(timeController.getTime('alarm'),);

                  final result = await addEventController.createTask(
                    title: addEventController.titleController.text.trim(),
                    date: addEventController.dateController.text.trim(),
                    startTime: start,
                    endTime: end,
                    location:addEventController.locationController.text.trim().isEmpty ? null : addEventController.locationController.text.trim(),
                    alarmTime: alarm,
                    categoryName: addEventController.selectedCategory?.isEmpty == true ? null : addEventController.selectedCategory,
                    note: addEventController.noteController.text.trim() ?? "",
                  );

                  debugPrint("START TIME SENT => $start");
                  debugPrint("END TIME SENT => $end");

                  if (result != null) {
                    final eventModel = EventModel.fromMap(result);
                    await AlarmHelper.scheduleEventAlarm(eventModel);

                    DateTime? alarmTime;
                    try {
                      alarmTime = DateTime.parse(result['alarm_time']);
                    } catch (e) {
                      debugPrint("⚠️ Alarm time format error: ${result['alarm_time']}",);
                    }

                    if (alarmTime != null) {
                      await NotificationService.scheduleNotification(
                        id: result['id'],
                        title: result['title'],
                        body: result['description'],
                        alarmTime: alarmTime,
                      );
                    }
                    await showMessageDialog(
                      context,
                      'Saved successfully',
                      title: 'Success',
                      icon: Icons.check_circle_outline,
                      iconColor: Colors.green,
                    );
                     Navigator.of(context).pop();
                  }
                } catch (e) {
                  await showMessageDialog(
                    context,
                    'Failed to save event: $e',
                    title: 'Error',
                    icon: Icons.error_outline,
                    iconColor: Colors.red,
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
          ],
        ),
      ),
    );
  }
}

// Consumer<AddEventController>(
//                 builder: (context, controller, _) {
//                   final categories = controller.categories;
//                   if (categories.isEmpty) {
//                     return Row(
//                       children: List.generate(3, (index) {
//                         return Row(
//                           children: [
//                             BulletButton(
//                               label: 'Loading...',
//                               color: AppColors.fourth_color,
//                               iconPath: 'assets/icons/bullet_point.svg',
//                             ),
//                             SizedBox(width: 16.w),
//                           ],
//                         );
//                       }),
//                     );
//                   }
//                   return Row(
//                     children: List.generate(categories.length, (index) {
//                       final category = categories[index];
//                       final color = index % 2 == 0
//                         ? AppColors.fourth_color
//                         : AppColors.fifth_color;
//                       return Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               debugPrint('Selected Category: ${category.name}');
//                               selectedCategory = category.name;
//                             },
//                             child: BulletButton(
//                               label: category.name,
//                               color: color,
//                               iconPath: 'assets/icons/bullet_point.svg',
//                             ),
//                           ),
//                           SizedBox(width: 16.w),
//                         ],
//                       );
//                     }),
//                   );
//                 },
//               ),
