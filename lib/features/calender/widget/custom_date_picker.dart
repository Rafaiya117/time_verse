import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_verse/core/utils/colors.dart';

class DatePickerDialog extends StatefulWidget {
  const DatePickerDialog({super.key});

  @override
  State<DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<DatePickerDialog> {
  DateTime _focusedDay = DateTime(2025, 9, 6);
  DateTime? _selectedDay = DateTime(2025, 9, 6);
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: isDarkMode?AppColors.containers_bgd:AppColors.background_color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            color: AppColors.third_color,
            child: Text(
              'Wed, September 6',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: Colors.white, 
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
            TableCalendar(
              firstDay: DateTime(2025, 8, 26),
              lastDay: DateTime(2025, 10, 4),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                Navigator.pop(context); 
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: isDarkMode?AppColors.fourth_color:AppColors.heading_color,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                defaultTextStyle:TextStyle(color: isDarkMode?AppColors.fourth_color:AppColors.heading_color),
                weekendTextStyle: TextStyle(color:isDarkMode?AppColors.fourth_color:AppColors.heading_color),
                // ignore: deprecated_member_use
                outsideTextStyle: TextStyle(color:Color(0xFFD3C29F).withOpacity(0.2)),
              ),
              headerStyle:HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: isDarkMode?AppColors.fourth_color:AppColors.heading_color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: isDarkMode?AppColors.fourth_color:AppColors.heading_color),
                rightChevronIcon: Icon(Icons.chevron_right, color: isDarkMode?AppColors.fourth_color:AppColors.heading_color),
              ),
              daysOfWeekStyle:DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: isDarkMode?AppColors.fourth_color:AppColors.heading_color),
                weekendStyle: TextStyle(color: isDarkMode?AppColors.fourth_color:AppColors.heading_color),
              ),
            ),
          ],
        ),
    );
  }
}
