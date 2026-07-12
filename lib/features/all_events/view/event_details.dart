// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_bottomnav.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/all_events/controller/event_details_controller.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final int eventId = state.extra is int ? state.extra as int : 0;
    Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final controller = Provider.of<EventController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchEventDetailsById(eventId);
    });
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Consumer<EventController>(
          builder: (context, eventController, _) {
            // ✅ FIX: Show a loader while eventDetail is null to prevent errors
            if (eventController.eventDetail == null) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFFB800)),
              );
            }
        
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 40.0.h),
              child: Column(
                children: [
                  CustomHeaderBar(
                    title:"Share Quote" , 
                    leftSpacing: 80, 
                    rightSpacing: 80
                  ),
                  SizedBox(height: 20.h),
        
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          // 🛠️ WRAPPED WITH REPAINTBOUNDARY TO ENABLE IMAGE CAPTURING
                          RepaintBoundary(
                            key: context.read<EventController>().quoteShareKey,
                            child: Container(
                              width: 327.w,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? null
                                    : const Color(0xFFFFFFFF),
                                gradient: isDarkMode
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFF0A1128),
                                          Color(0xFF1A1F3A),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFFB703,
                                  ).withOpacity(0.4),
                                  width: 1.w,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 30.h,
                                  horizontal: 24.w,
                                ),
                                child: Consumer<EventController>(
                                  builder: (context, eventController, _) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // 1. Category Icon
                                        Container(
                                          width: 64.w,
                                          height: 64.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          padding: EdgeInsets.all(8.w),
                                          child: SvgPicture.asset(
                                            isDarkMode? 'assets/icons/graduation_icon.svg': 'assets/icons/graduation_light.svg',
                                            width: 70.w,
                                            height: 70.h,
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        // 2. Event Title Text
                                        Text(
                                          eventController.eventDetail?.title ??'Traveling to grandmother',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                            fontSize: 27.sp,
                                            fontWeight: FontWeight.bold,
                                            color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        // 3. Date & Time Subtitle
                                        Text(
                                          'Today • ${eventController.eventDetail?.startTime ?? "2:00 PM"}',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.outfit(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: isDarkMode
                                            ? const Color(0xFF9CA3AF)
                                            : Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 14.h),
                                        // 4. Elegant Center Divider Line
                                        Row(
                                          mainAxisAlignment:MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 1.h,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      const Color(
                                                        0xFFFFB703,
                                                      ).withOpacity(0.5),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                                              child: SvgPicture.asset(
                                                'assets/icons/sparkle.svg',
                                                width: 12.w,
                                                height: 12.h,
                                                colorFilter:
                                                  const ColorFilter.mode(
                                                    Color(0xFFFFB703),
                                                    BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 1.h,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0xFFFFB703).withOpacity(0.5),
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 24.h),
                                        // 5. Quote Description Text Area
                                        Column(
                                          mainAxisAlignment:MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                                              child: Text(
                                                '“ ${eventController.eventDetail?.description ?? 'Every journey towards family weaves new tales in the tapestry of our souls, binding us closer with each step.'} ”',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.inter(
                                                  fontSize: 24.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 24.h),
                                        // 6. Author Name
                                        Text(
                                          '-${eventController.eventDetail?.userName ?? "pappu roy"}',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.outfit(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFFFB703),
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        // 7. Context Footer Text
                                        Text(
                                          'Inspired for your moment',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.outfit(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF4B5563),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            text: "Save",
                            onPressed: () async {
                              final eventController =
                                  Provider.of<EventController>(
                                    context,
                                    listen: false,
                                  );
                              await eventController.shareQuoteAsImage();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Quote saved as image!')),
                              );
                            },
                            borderGradient: AppGradientColors.button_gradient,
                            solidColor: isDarkMode
                            ? AppColors.containers_bgd
                            : AppColors.background_color,
                            textColor: isDarkMode
                            ? AppColors.text_color
                            : const Color(0xFF373F4B),
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
                              color: isDarkMode
                              ? AppColors.text_color
                              : const Color(0xFF373F4B),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          CustomButton(
                            text: "Share",
                            onPressed: () {
                              debugPrint('button clicked');
                              context.read<EventController>().shareQuoteToSocialMedia();
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
                        onPressed: () {
                          context.push('/all_events');
                        },
                        child: Text(
                          'Explore more quotes  →',
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal,
                            color: isDarkMode?AppColors.background_color:AppColors.heading_color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
