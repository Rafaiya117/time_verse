import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
    return Dialog(
      backgroundColor: const Color(0xFF1C1C2D), // Dark background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Wed, September 6',
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
                Navigator.pop(context); // Close dialog on selection
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.yellow.shade700,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                defaultTextStyle: const TextStyle(color: Colors.yellow),
                weekendTextStyle: const TextStyle(color: Colors.yellow),
                outsideTextStyle: TextStyle(color: Colors.yellow.withOpacity(0.4)),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: Colors.yellow,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.yellow),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.yellow),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.yellow),
                weekendStyle: TextStyle(color: Colors.yellow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
