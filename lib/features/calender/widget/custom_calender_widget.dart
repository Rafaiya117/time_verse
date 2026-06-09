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
          return controller.events.where((event) {
            final eventDate = DateTime.tryParse(event.createdAt); 
            return eventDate != null && isSameDay(eventDate, day);
          }).toList();
        },

        // --- HEADER STYLE ---
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFFF5B301), size: 28.sp), 
          rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFFF5B301), size: 28.sp), 
          headerPadding: EdgeInsets.symmetric(vertical: 12.h),
          titleTextStyle: const TextStyle(height: 0), 
          titleTextFormatter: (date, locale) => '', 
        ),

        // --- CUSTOM BUILDERS (HEADER & WEEKDAYS) ---
        calendarBuilders: CalendarBuilders(
          headerTitleBuilder: (context, date) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _monthName(date.month),
                  style: GoogleFonts.outfit(
                    color: Color(0xFFF5B301), 
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500, 
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${date.year}',
                  style: GoogleFonts.outfit(
                    color: Color(0xFFF5B301), 
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
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

        // --- CALENDAR GRID NUMBERS STYLE ---
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          markerDecoration: const BoxDecoration(
            color: goldColor,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: goldColor, 
            shape: BoxShape.rectangle, // Explicitly rectangular
            borderRadius: BorderRadius.circular(12.r), 
          ),
          selectedTextStyle: GoogleFonts.outfit(
            color: Colors.black, 
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
          todayDecoration: BoxDecoration(
            color: goldColor.withOpacity(0.3), 
            shape: BoxShape.rectangle, // Explicitly rectangular
            borderRadius: BorderRadius.circular(12.r),
          ),
          todayTextStyle: GoogleFonts.outfit(
            color: whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
          
          // 💡 Fix: Explicitly turned unselected shapes into rectangles to prevent shape conflicts during selections
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
          markersAlignment: Alignment.bottomCenter,
          cellMargin: EdgeInsets.all(5.w),
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