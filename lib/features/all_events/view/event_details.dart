import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/all_events/controller/event_details_controller.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final int eventId = state.extra is int ? state.extra as int : 0;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final controller = Provider.of<EventController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchEventDetailsById(eventId);
    });
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 32.0.h),
        child:Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: (){
                    context.pop();
                  }, 
                  icon: SvgPicture.asset(
                    'assets/icons/arrow_back.svg',
                    width: 17.5.w,
                    height: 15.01.h,
                    // ignore: deprecated_member_use
                    color: isDarkMode?AppColors.text_color:AppColors.heading_color,
                  ),
                ),
                SizedBox(width: 90.w,),
                Text(
                  'Share Quote',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: isDarkMode? AppColors.text_color: AppColors.heading_color,
                  ),
                ),
                SizedBox(width: 45.w,),
                IconButton(
                  onPressed: (){
                    themeProvider.toggleTheme();
                  }, 
                  icon: SvgPicture.asset(
                    isDarkMode?'assets/icons/theme_dark.svg':'assets/icons/light_theme.svg',
                    width: 15.w,
                    height: 15.h,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 327.w,
                      height: 430.h,
                      decoration: BoxDecoration(
                        color: isDarkMode ? null : const Color(0xFFB4AB9C),
                        gradient: isDarkMode
                          ? LinearGradient(
                            colors: [Color(0xFF0A1128), Color(0xFF1A1F3A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 50.h),
                        child:Consumer<EventController>(
                          builder: (context, eventController, _) {
                            return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/graduation_icon.svg',
                                  width: 48.w,
                                  height: 48.h,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  eventController.eventDetail?.title?? 'Mathematics Final Exam',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                      ? AppColors.text_color
                                      : AppColors.heading_color,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 50.0.w),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.normal,
                                    color: isDarkMode
                                      ? AppColors.third_color
                                      : AppColors.heading_color,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Today • '),
                                    TextSpan(
                                      text:eventController.eventDetail?.startTime ??'2:00 PM  ',
                                      style: GoogleFonts.outfit(
                                        color: isDarkMode
                                          ? AppColors.third_color
                                          : AppColors.heading_color,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 2.h,left: 8.w),
                                        child: SvgPicture.asset(
                                          'assets/icons/clock.svg',
                                          width: 14.w,
                                          height: 14.h,
                                        ),
                                      ),
                                    ),
                                    const WidgetSpan(child: SizedBox(width: 8)),
                                    TextSpan(
                                      text: eventController.formatTime(eventController.eventDetail?.alarmTime??'1:30 PM'),
                                      style: GoogleFonts.outfit(
                                        color: isDarkMode
                                          ? AppColors.third_color
                                          : AppColors.heading_color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Column(
                              children: [
                                SvgPicture.asset(
                                  isDarkMode
                                    ? 'assets/icons/star_dark.svg'
                                    : 'assets/icons/star_light.svg',
                                  width: 21.33.w,
                                  height: 21.33.h,
                                ),
                                SvgPicture.asset(
                                  isDarkMode
                                    ? 'assets/icons/prograss_bar.svg'
                                    : 'assets/icons/prograssbar_light.svg',
                                  width: 64.w,
                                  height: 4.h,
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.all(12.0.w),
                                width: 248.w,
                                height: 230.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: isDarkMode
                                    ? AppColors.containers_bgd
                                    : AppColors.text_color,
                                ),
                                child: Column(
                                  children: [
                                    Consumer<EventController>(
                                    builder: (context, eventController, _) =>
                                    RepaintBoundary(
                                      key: eventController.quoteShareKey,
                                      child: Text(
                                        eventController.eventDetail?.description ??eventController.quoteText,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.outfit(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.normal,
                                          color: isDarkMode
                                            ? AppColors.text_color
                                            : AppColors.heading_color,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 40.h),
                                    Text(
                                      'Name ${eventController.eventDetail?.userName??'xyz'}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 13.6.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.fourth_color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 1.h,
                      right: 1.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.r),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/corner_icon.svg',
                          width: 80.w,
                          height: 80.h,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 1.h,
                      left: 1.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                        ),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: SvgPicture.asset(
                            'assets/icons/corner_icon.svg',
                            width: 80.w,
                            height: 80.h,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 1.h,
                      right: 1.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16.r),
                        ),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationX(math.pi),
                          child: SvgPicture.asset(
                            'assets/icons/corner_icon.svg',
                            width: 80.w,
                            height: 80.h,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SvgPicture.asset(
                          isDarkMode
                            ? 'assets/icons/prograss_bar.svg'
                            : 'assets/icons/prograssbar_light.svg',
                          width: 64.w,
                          height: 4.h,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 1.h,
                      left: 1.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.r),
                        ),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationX(math.pi)
                            ..rotateY(math.pi),
                          child: SvgPicture.asset(
                            'assets/icons/corner_icon.svg',
                            width: 80.w,
                            height: 80.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(
                  'Generated by AI for your\n moment',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: isDarkMode
                      ? AppColors.text_color
                      : AppColors.heading_color,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: "Save",
                      onPressed: () {},
                      borderGradient: AppGradientColors.button_gradient,
                      solidColor: isDarkMode
                        ? AppColors.containers_bgd
                        : AppColors.background_color,
                      textColor: isDarkMode?AppColors.text_color:Color(0xFF373F4B),
                      fontFamily: 'outfit',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                      height: 48.h,
                      width: 159.w,
                      leadingIcon: SvgPicture.asset(
                        'assets/icons/download.svg',
                        width: 18.w,
                        height: 18.h,
                        // ignore: deprecated_member_use
                        color: isDarkMode?AppColors.text_color:Color(0xFF373F4B),
                      ),
                    ),
                    SizedBox(width:10.w),
                    CustomButton(
                      text: "Share",
                      onPressed: () {
                        context.read<EventController>().shareQuoteAsImage();
                      },
                      gradient: AppGradientColors.button_gradient,
                      textColor: AppColors.text_color,
                      fontFamily: 'outfit',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                      height: 48.h,
                      width: 159.w,
                      leadingIcon: SvgPicture.asset(
                        'assets/icons/share_filled.svg',
                        width: 18.w,
                        height: 18.h,
                        // ignore: deprecated_member_use
                        color: AppColors.text_color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                TextButton(
                  onPressed: (){
                    context.push('/all_events');
                  }, 
                  child: Text(
                    'See all Qoutes',
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: AppColors.third_color,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}