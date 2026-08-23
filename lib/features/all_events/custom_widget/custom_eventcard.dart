import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/core/utils/colors.dart';

// class EventCard extends StatelessWidget {
//   final int id;
//   final String title;
//   final String sub_title;
//   final String date;
//   final String time;
//   final String location;
//   final VoidCallback onDelete;
//   final VoidCallback onEdit;
//   final bool isDarkMode;

//   const EventCard({
//     super.key,
//     required this.id,
//     required this.sub_title,
//     required this.title,
//     required this.date,
//     required this.time,
//     required this.location,
//     required this.onDelete,
//     required this.onEdit,
//     required this.isDarkMode,
//   });

//   @override
//   Widget build(BuildContext context) {
//     bool isValidLocation(String loc) {
//       final clean = loc.trim().toLowerCase();
//       if (clean.isEmpty || clean == 'unknown') return false;
//       if (clean.endsWith('@google.com')) return false;
//       return true;
//     }
//     return GestureDetector(
//       onTap: () {
//         context.push('/event_details', extra: id);
//       },
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: isDarkMode ? AppColors.containers_bgd : Colors.white,
//           borderRadius: BorderRadius.circular(12.r),
//           border: Border.all(color: AppColors.third_color),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             SvgPicture.asset(
//                               'assets/icons/tittle_icon.svg',
//                               height: 23.sp,
//                               width: 23.sp,
//                             ),
//                             Text(
//                               title,
//                               style: GoogleFonts.cormorant(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 16.sp,
//                                 color: isDarkMode ? AppColors.text_color: const Color(0xFF353535),
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 10.h),
//                         Text(
//                           sub_title,
//                           style: GoogleFonts.outfit(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 12.sp,
//                             color: isDarkMode
//                             ? AppColors.text_color: const Color(0xFF353535),
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: onEdit,
//                     child: Icon(
//                       Icons.edit_outlined,
//                       size: 22.sp,
//                       color: isDarkMode ? AppColors.text_color : const Color(0xFF353535),
//                     ),
//                   ),
//                   SizedBox(width: 10.w),
//                   GestureDetector(
//                     onTap: onDelete,
//                     child: SvgPicture.asset(
//                       'assets/icons/delete_icon.svg',
//                       width: 30.w,
//                       height: 30.h,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SvgPicture.asset(
//                     'assets/icons/today.svg',
//                     width: 15.w,
//                     height: 15.h,
//                   ),
//                   SizedBox(width: 10.w),
//                   Text(
//                     date,
//                     style: GoogleFonts.outfit(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 12.sp,
//                       color: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 15.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SvgPicture.asset(
//                     'assets/icons/clock_icon.svg',
//                     width: 15.w,
//                     height: 15.h,
//                   ),
//                   SizedBox(width: 15.w),
//                   Text(
//                     time,
//                     style: GoogleFonts.outfit(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 12.sp,
//                       color: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B),
//                     ),
//                   ),
//                 ],
//               ),
//               if (isValidLocation(location)) ...[
//                 SizedBox(height: 15.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SvgPicture.asset(
//                       'assets/icons/pin.svg',
//                       width: 20.w,
//                       height: 20.h,
//                     ),
//                     SizedBox(width: 10.w),
//                     Expanded(
//                       child: Text(
//                         location,
//                         style: GoogleFonts.outfit(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12.sp,
//                           color: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B),
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//               SizedBox(height: 10.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class EventCard extends StatelessWidget {
  final int id;
  final String title;
  final String sub_title;
  final String date;
  final String time;
  final String location;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isDarkMode;

  const EventCard({
    super.key,
    required this.id,
    required this.sub_title,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.onDelete,
    required this.onEdit,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    bool isValidLocation(String loc) {
      final clean = loc.trim();
      if (clean.isEmpty || clean.toLowerCase() == 'unknown') return false;
      if (clean.toLowerCase().endsWith('@google.com')) return false;

      // Checks if location is a single long alphanumeric string (Google ID format)
      final isGoogleId = !clean.contains(' ') &&
          clean.length >= 20 &&
          RegExp(r'^[a-zA-Z0-9]+$').hasMatch(clean);

      return !isGoogleId;
    }

    return GestureDetector(
      onTap: () {
        context.push('/event_details', extra: id);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.containers_bgd : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.third_color),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/tittle_icon.svg',
                              height: 23.sp,
                              width: 23.sp,
                            ),
                            Text(
                              title,
                              style: GoogleFonts.cormorant(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                                color: isDarkMode ? AppColors.text_color: const Color(0xFF353535),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          sub_title,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: isDarkMode
                            ? AppColors.text_color: const Color(0xFF353535),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onEdit,
                    child: Icon(
                      Icons.edit_outlined,
                      size: 22.sp,
                      color: isDarkMode ? AppColors.text_color : const Color(0xFF353535),
                    ),
                  ),
                  SizedBox(width: 10.w),
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
                    'assets/icons/today.svg',
                    width: 15.w,
                    height: 15.h,
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
              if (isValidLocation(location)) ...[
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/pin.svg',
                      width: 20.w,
                      height: 20.h,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        location,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}