import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/features/calender/controller/time_controller.dart';

class TimePickerField extends StatelessWidget {
  final String fieldKey;
  final String label;
  final Color? textColor;
  final double? fontSize;
  final TextEditingController? textController;

  const TimePickerField({
    super.key,
    required this.fieldKey,
    required this.label,
    this.textColor,
    this.fontSize,
    this.textController,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final controller = Provider.of<TimePickerController>(context);
    final time = controller.getTime(fieldKey);
    final formattedTime = controller.formatTime(time);

    return GestureDetector(
      onTap: () => controller.selectTime(context, fieldKey),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top small label (e.g., Start Time)
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: isDarkMode?Colors.white: Colors.black, // Matches the dim description style
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 4.h),
                // Bottom dynamic time value (e.g., 7:00 PM)
                Text(
                  time != null
                      ? formattedTime
                      : (textController?.text.isNotEmpty == true
                          ? textController!.text
                          : "Select Time"),
                  style: GoogleFonts.inter(
                    color: isDarkMode?Colors.white: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600, // Semi-bold style for the values
                  ),
                ),
              ],
            ),
          ),
          // Clean orange dropdown arrow matching design image exactly
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: const Color(0xFFFFA500),
            size: 22.sp,
          ),
        ],
      ),
    );
  }
}