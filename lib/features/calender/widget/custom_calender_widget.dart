import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_verse/features/calender/controller/calender_controller.dart';

class FancyCalendarView extends StatelessWidget {
  const FancyCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.orange : const Color(0xFF373F4B);

    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
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

        // --- HEADER STYLE ---
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          leftChevronIcon:Icon(Icons.chevron_left, color: textColor, size: 24.sp),
          rightChevronIcon:Icon(Icons.chevron_right, color: textColor, size: 24.sp),
          titleTextStyle: GoogleFonts.outfit(
            color: textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
          headerPadding: EdgeInsets.symmetric(vertical: 8.h),
          titleTextFormatter: (date, locale) {
            final month = _monthName(date.month);
            final year = '${date.year}';
            return '$month\n$year';
          },
        ),

        // --- DAYS OF WEEK STYLE ---
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.outfit(
            // ignore: deprecated_member_use
            color: textColor.withOpacity(0.7),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          weekendStyle: GoogleFonts.outfit(
            // ignore: deprecated_member_use
            color: textColor.withOpacity(0.7),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),

        // --- CALENDAR STYLE ---
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          todayDecoration: BoxDecoration(
            color: isDarkMode ? Colors.orange.shade600 : const Color(0xFF373F4B),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: isDarkMode ? Colors.orange : const Color(0xFF373F4B),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: GoogleFonts.outfit(
            color: isDarkMode ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
          todayTextStyle: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
          defaultTextStyle: GoogleFonts.outfit(
            color: textColor,
            fontSize: 14.sp,
          ),
          weekendTextStyle: GoogleFonts.outfit(
            color: textColor,
            fontSize: 14.sp,
          ),
          outsideTextStyle: GoogleFonts.outfit(
            color: textColor.withOpacity(0.2),
            fontSize: 14.sp,
          ),
          markersAlignment: Alignment.bottomCenter,
          cellMargin: EdgeInsets.all(6.w),
        ),

        calendarFormat: CalendarFormat.month,
      ),
    );
  }
}

/// ✅ Helper to return month name
String _monthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return months[month - 1];
}
