// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/calender/controller/calender_controller.dart';

class FancyCalendarView extends StatelessWidget {
  const FancyCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    const goldColor = Color(0xFFFFA500); 
    const whiteColor = Colors.white; 

    final int todayWeekday = DateTime.now().weekday;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: controller.focusedDay,
        selectedDayPredicate: (day) => isSameDay(controller.selectedDay, day),
        onDaySelected: controller.onDaySelected,

        eventLoader: (day) {
          final current = DateTime(day.year, day.month, day.day);

          return controller.events.where((event) {
            final rawDateStr = event.createdAt.isNotEmpty
                ? event.createdAt
                : event.date;
            final startDate = DateTime.tryParse(rawDateStr);
            if (startDate == null) return false;

            final start = DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
            );

            if (current.isBefore(start)) return false;
            if (start.year == current.year &&
                start.month == current.month &&
                start.day == current.day) {
              return true;
            }

            final repeatRule = event.repeat?.toLowerCase().trim() ?? '';
            if (repeatRule.isEmpty) return false;

            switch (repeatRule) {
              case '1 day':
              case 'every 1 day':
                return true;
              case '1 week':
              case 'every 1 week':
                return current.difference(start).inDays % 7 == 0;
              case '1 month':
              case 'every 1 month':
                return current.day == start.day;
              case '1 year':
              case 'every 1 year':
                return current.month == start.month && current.day == start.day;
              default:
                return false;
            }
          }).toList();
        },

        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          leftChevronIcon: Icon(Icons.chevron_left, color: const Color(0xFFF5B301), size: 28.sp), 
          rightChevronIcon: Icon(Icons.chevron_right, color: const Color(0xFFF5B301), size: 28.sp), 
          headerPadding: EdgeInsets.symmetric(vertical: 12.h),
          titleTextStyle: const TextStyle(height: 0), 
          titleTextFormatter: (date, locale) => '', 
        ),

        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            return const SizedBox.shrink();
          },

          headerTitleBuilder: (context, date) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: controller.focusedDay,
                  firstDate: DateTime(2020, 1, 1),
                  lastDate: DateTime(2030, 12, 31),
                  initialDatePickerMode: DatePickerMode.year,
                );

                if (selectedDate != null) {
                  controller.onDaySelected(selectedDate, selectedDate);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _monthName(date.month),
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFF5B301), 
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500, 
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_drop_down,
                        color: const Color(0xFFF5B301),
                        size: 24.sp,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${date.year}',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFF5B301), 
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          },
          
          dowBuilder: (context, day) {
            final text = _weekdayName(day.weekday);
            final isTodayWeekday = day.weekday == todayWeekday;

            return Center(
              child: Text(
                text,
                style: GoogleFonts.outfit(
                  color: isTodayWeekday ? goldColor : (isDarkMode ? whiteColor : const Color(0xFF7B7B7B)), 
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),

        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          markerDecoration: const BoxDecoration(
            color: goldColor,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: goldColor, 
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12.r), 
          ),
          selectedTextStyle: GoogleFonts.outfit(
            color: Colors.black, 
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
          todayDecoration: BoxDecoration(
            color: goldColor.withOpacity(0.3), 
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12.r),
          ),
          todayTextStyle: GoogleFonts.outfit(
            color: whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
          defaultDecoration: const BoxDecoration(
            shape: BoxShape.rectangle,
          ),
          weekendDecoration: const BoxDecoration(
            shape: BoxShape.rectangle,
          ),
          outsideDecoration: const BoxDecoration(
            shape: BoxShape.rectangle,
          ),
          defaultTextStyle: GoogleFonts.outfit(
            color: isDarkMode ? whiteColor : AppColors.heading_color, 
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            shadows: [
              if (!isDarkMode)
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          weekendTextStyle: GoogleFonts.outfit(
            color: isDarkMode ? whiteColor : AppColors.heading_color,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            shadows: [
              if (!isDarkMode)
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          outsideTextStyle: GoogleFonts.outfit(
            color: isDarkMode ? whiteColor.withOpacity(0.25) : AppColors.heading_color.withOpacity(0.2), 
            fontSize: 14.sp,
            shadows: [
              if (!isDarkMode)
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String _monthName(int month) {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return months[month - 1];
}

String _weekdayName(int weekday) {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']; 
  return days[weekday - 1];
}