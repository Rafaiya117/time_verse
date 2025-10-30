import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_verse/features/calender/controller/calender_controller.dart';

class FancyCalendarView extends StatelessWidget {
  const FancyCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
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
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white, size: 24.sp),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white, size: 24.sp),
          titleTextStyle: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
          headerPadding: EdgeInsets.symmetric(vertical: 8.h),
        ),

        // --- DAYS OF WEEK STYLE ---
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          weekendStyle: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),

        // --- CALENDAR STYLE ---
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          todayDecoration: BoxDecoration(
            color: Colors.orange.shade600,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
          todayTextStyle: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
          defaultTextStyle: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14.sp,
          ),
          weekendTextStyle: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14.sp,
          ),
          outsideTextStyle: GoogleFonts.inter(
            color: Colors.white24,
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
