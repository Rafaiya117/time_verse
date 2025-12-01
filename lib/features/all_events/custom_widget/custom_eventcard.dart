import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/core/utils/colors.dart';

class EventCard extends StatelessWidget {
  final int id;
  final String title;
  final String date;
  final String time;
  final String location;
  final VoidCallback onDelete;
  final bool isDarkMode;

  const EventCard({
    Key? key,
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.onDelete,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.push('/event_details', extra: id);
      },
      child:Container(
      width: 327.w,
      height: 155.h,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.containers_bgd : Color(0xFFF4F6F5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.third_color,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: isDarkMode ? AppColors.text_color : const Color(0xFF353535),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onDelete,
                  child: SvgPicture.asset(
                    'assets/icons/delete_icon.svg',
                    width: 30.w,
                    height: 30.h,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/icons/calender_icon.svg',
                  width: 20.w,
                  height: 20.h,
                ),
                SizedBox(width: 10.w),
                Text(
                  date,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/icons/clock_icon.svg',
                  width: 15.w,
                  height: 15.h,
                ),
                SizedBox(width: 15.w),
                Text(
                  time,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/icons/location_icon.svg',
                  width: 20.w,
                  height: 20.h,
                ),
                SizedBox(width: 10.w),
                Text(
                  location,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
