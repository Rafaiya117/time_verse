import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final bool isDarkMode;

  const CustomDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.isDarkMode,
  });

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  late DateTime _temporarySelectedDay;
  late DateTime _temporaryFocusedDay;

  @override
  void initState() {
    super.initState();
    _temporarySelectedDay = widget.initialDate;
    _temporaryFocusedDay = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    // Exact hex background values pulled directly from your dark/light UI mockup profiles
    final backgroundColor = widget.isDarkMode ? const Color(0xFF0F172A) : Colors.white;
    final weekdayColor = widget.isDarkMode ? Colors.white60 : Colors.black54;

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- TOP HEADER BANNER ---
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF5B301),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_temporarySelectedDay.year}',
                  style: GoogleFonts.outfit(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  DateFormat('EEE, MMMM d').format(_temporarySelectedDay),
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // --- CALENDAR GRID ---
          Padding(
            padding: EdgeInsets.all(12.w),
            child: TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _temporaryFocusedDay,
              headerVisible: true,
              
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                leftChevronIcon: Icon(Icons.chevron_left, color: const Color(0xFFF5B301), size: 24.sp),
                rightChevronIcon: Icon(Icons.chevron_right, color: const Color(0xFFF5B301), size: 24.sp),
                titleTextStyle: GoogleFonts.outfit(
                  color: const Color(0xFFF5B301),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              selectedDayPredicate: (day) => isSameDay(_temporarySelectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _temporarySelectedDay = selectedDay;
                  _temporaryFocusedDay = focusedDay;
                });
              },
              
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.outfit(color: weekdayColor, fontSize: 13.sp),
                weekendStyle: GoogleFonts.outfit(color: weekdayColor, fontSize: 13.sp),
              ),
              
              calendarStyle: CalendarStyle(
                isTodayHighlighted: false,
                selectedDecoration: const BoxDecoration(
                  color: Color(0xFFF5B301),
                  shape: BoxShape.rectangle,
                ),
                selectedTextStyle: GoogleFonts.outfit(
                  color: widget.isDarkMode ? const Color(0xFF0F172A) : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
                defaultDecoration: const BoxDecoration(shape: BoxShape.rectangle),
                weekendDecoration: const BoxDecoration(shape: BoxShape.rectangle),
                outsideDecoration: const BoxDecoration(shape: BoxShape.rectangle),
                
                // Matches the custom colored floating digits
                defaultTextStyle: GoogleFonts.outfit(
                  color: const Color(0xFFFFA500),
                  fontSize: 14.sp,
                ),
                weekendTextStyle: GoogleFonts.outfit(
                  color: const Color(0xFFFFA500),
                  fontSize: 14.sp,
                ),
                outsideTextStyle: GoogleFonts.outfit(
                  color: widget.isDarkMode ? Colors.white30 : Colors.black26,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          
          // --- DIALOG ACTIONS ---
          Padding(
            padding: EdgeInsets.only(right: 16.w, bottom: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.outfit(color: const Color(0xFFF5B301), fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(width: 8.w),
                TextButton(
                  onPressed: () => Navigator.pop(context, _temporarySelectedDay),
                  child: Text(
                    'OK',
                    style: GoogleFonts.outfit(color: const Color(0xFFF5B301), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}