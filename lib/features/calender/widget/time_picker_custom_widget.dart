import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/calender/controller/time_controller.dart';

class TimePickerField extends StatelessWidget {
  final String fieldKey;
  final String label; 
  final dynamic icon; 
  final Color? borderColor;
  final Color? textColor;
  final double? fontSize;
  final TextEditingController? textController;
  
  const TimePickerField({
    super.key,
    required this.fieldKey,
    required this.label,
    required this.icon,
    this.borderColor,
    this.textColor,
    this.fontSize,
    this.textController, 
  });

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TimePickerController>(context);
    final time = controller.getTime(fieldKey);
    final formattedTime = controller.formatTime(time);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => controller.selectTime(context, fieldKey),
      child: Container(
        width: 170.w,
        height: 50.h,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.fourth_color,),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time != null
                ? formattedTime : (textController?.text.isNotEmpty == true
                ? textController!.text : label),
              style: GoogleFonts.outfit(
                color: isDarkMode?AppColors.text_color:AppColors.heading_color,
                fontSize: fontSize ?? 15,
              ),
            ),
            SizedBox(width: 8),
            _buildIcon(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (icon is String && icon.toString().endsWith('.svg')) {
      return SvgPicture.asset(
        icon,
        width: 20,
        height: 20,
        colorFilter:ColorFilter.mode(isDarkMode?AppColors.text_color:AppColors.heading_color, BlendMode.srcIn),
      );
    } else if (icon is IconData) {
      return Icon(icon, color: isDarkMode?AppColors.text_color:AppColors.heading_color, size: 20);
    } else {
      return const SizedBox.shrink();
    }
  }
}