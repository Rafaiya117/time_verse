import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/calender/controller/add_event_controller.dart';

void showCustomRepeatDialog(BuildContext context, AddEventController controller) {
  int tempCount = controller.customRepeatCount;
  String tempUnit = controller.customRepeatUnit;
  List<String> tempDays = List.from(controller.selectedDays);
  String tempEndType = controller.repeatEndType;
  DateTime tempEndDate = controller.customEndDate;
  int tempOccurrences = controller.customOccurrences;

  final weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          // Dynamic colors mapped to AppColors
          final dialogBgColor = isDark ? AppColors.containers_bgd : const Color(0xFFF8F9FA);
          final titleColor = isDark ? AppColors.text_color : AppColors.l_text_clr;
          final subTextColor = isDark ? AppColors.secendary_text_color : AppColors.l_text_clr2;
          final activeColor = isDark ? AppColors.button_color : AppColors.save_color;
          final borderColor = isDark ? AppColors.secendary_text_color.withValues(alpha: 0.3) : AppColors.container;
          final dropdownBgColor = isDark ? AppColors.containers_bgd : Colors.white;

          return Dialog(
            backgroundColor: dialogBgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Custom recurrence',
                    style: GoogleFonts.inter(
                      color: titleColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Repeats every
                  Text(
                    'Repeats every',
                    style: GoogleFonts.inter(
                      color: subTextColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        width: 55.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: TextFormField(
                          initialValue: '$tempCount',
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(color: titleColor, fontSize: 14.sp),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (val) {
                            tempCount = int.tryParse(val) ?? 1;
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        height: 40.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: tempUnit,
                            dropdownColor: dropdownBgColor,
                            style: GoogleFonts.inter(color: titleColor, fontSize: 14.sp),
                            items: ['day', 'week', 'month', 'year'].map((String unit) {
                              return DropdownMenuItem<String>(
                                value: unit,
                                child: Text(tempCount > 1 ? '${unit}s' : unit),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() => tempUnit = val);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),
                  Divider(color: borderColor, height: 1),
                  SizedBox(height: 16.h),

                  // Repeats on
                  if (tempUnit == 'week') ...[
                    Text(
                      'Repeats on',
                      style: GoogleFonts.inter(
                        color: subTextColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        final dayLabel = weekDays[index];
                        final isSelected = tempDays.contains('$dayLabel-$index');
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              final key = '$dayLabel-$index';
                              if (isSelected) {
                                tempDays.remove(key);
                              } else {
                                tempDays.add(key);
                              }
                            });
                          },
                          child: Container(
                            width: 34.w,
                            height: 34.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? activeColor : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? activeColor : borderColor,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                dayLabel,
                                style: GoogleFonts.inter(
                                  color: isSelected ? Colors.white : titleColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20.h),
                    Divider(color: borderColor, height: 1),
                    SizedBox(height: 16.h),
                  ],

                  // Ends
                  Text(
                    'Ends',
                    style: GoogleFonts.inter(
                      color: subTextColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Never
                  InkWell(
                    onTap: () => setDialogState(() => tempEndType = 'Never'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Never',
                            groupValue: tempEndType,
                            activeColor: activeColor,
                            onChanged: (val) => setDialogState(() => tempEndType = val!),
                          ),
                          Text('Never', style: GoogleFonts.inter(color: titleColor, fontSize: 14.sp)),
                        ],
                      ),
                    ),
                  ),

                  // On Date
                  InkWell(
                    onTap: () => setDialogState(() => tempEndType = 'On'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'On',
                            groupValue: tempEndType,
                            activeColor: activeColor,
                            onChanged: (val) => setDialogState(() => tempEndType = val!),
                          ),
                          Text('On', style: GoogleFonts.inter(color: titleColor, fontSize: 14.sp)),
                          SizedBox(width: 12.w),
                          GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempEndDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2035),
                              );
                              if (picked != null) {
                                setDialogState(() {
                                  tempEndDate = picked;
                                  tempEndType = 'On';
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                border: Border.all(color: borderColor),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                DateFormat('MMM d, yyyy').format(tempEndDate),
                                style: GoogleFonts.inter(color: titleColor, fontSize: 13.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // After Occurrences
                  InkWell(
                    onTap: () => setDialogState(() => tempEndType = 'After'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'After',
                            groupValue: tempEndType,
                            activeColor: activeColor,
                            onChanged: (val) => setDialogState(() => tempEndType = val!),
                          ),
                          Text('After', style: GoogleFonts.inter(color: titleColor, fontSize: 14.sp)),
                          SizedBox(width: 12.w),
                          Container(
                            width: 50.w,
                            height: 36.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: borderColor),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: TextFormField(
                              initialValue: '$tempOccurrences',
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(color: titleColor, fontSize: 13.sp),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (val) {
                                tempOccurrences = int.tryParse(val) ?? 1;
                                tempEndType = 'After';
                              },
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            tempOccurrences > 1 ? 'occurrences' : 'occurrence',
                            style: GoogleFonts.inter(color: titleColor, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Bottom Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            color: activeColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      TextButton(
                        onPressed: () {
                          controller.setCustomRepeat(
                            count: tempCount,
                            unit: tempUnit,
                            days: tempDays,
                            endType: tempEndType,
                            endDate: tempEndDate,
                            occurrences: tempOccurrences,
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Done',
                          style: GoogleFonts.inter(
                            color: activeColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}