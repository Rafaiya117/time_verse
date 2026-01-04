import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_verse/core/utils/colors.dart';

class DatePickerDialog extends StatefulWidget {
  // const DatePickerDialog({super.key});
  final TextEditingController controller;
  const DatePickerDialog({super.key, required this.controller});

  @override
  State<DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<DatePickerDialog> {
  final DateTime _today = DateTime.now();
  late DateTime _focusedDay = _today;
  DateTime? _selectedDay;

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
              DateFormat('EEE, MMMM d').format(_selectedDay ?? _focusedDay),
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
            firstDay: DateTime(_today.year, 1, 1),
            lastDay: DateTime(_today.year, 12, 31),
            focusedDay: _focusedDay ?? _today,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            enabledDayPredicate: (day) {
              return !day.isBefore(DateTime(_today.year, 1, 1)) &&
                !day.isAfter(DateTime(_today.year, 12, 31));
            },
            onDaySelected: (selectedDay, focusedDay) {
              final DateTime today = DateTime(_today.year, _today.month, _today.day);
                if (selectedDay.isBefore(today)) {
                  return;
                }
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              widget.controller.text = DateFormat('yyyy-MM-dd',).format(selectedDay);
                debugPrint("Selected date: ${widget.controller.text}");
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
