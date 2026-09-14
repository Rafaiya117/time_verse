// ignore_for_file: invalid_use_of_protected_member, deprecated_member_use
import 'dart:math';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_bottomnav.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/all_events/controller/event_details_controller.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';


class EventDetails extends StatelessWidget {
  final int eventId;
  const EventDetails({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final eventController = Provider.of<EventController>(context, listen: false);

    return Scaffold(
      extendBody: true,
      body: RefreshIndicator(
        onRefresh: () async {
          await eventController.fetchEventDetailsById(eventId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: FutureBuilder<EventModel?>(
            future: eventController.fetchEventDetailsById(eventId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerLoading(context, isDarkMode);
              }

              if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 80.0.h),
                  child: Center(
                    child: Text(
                      'Failed to load event details.',
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                );
              }

              // final eventDetail = snapshot.data!;
              // final currentQuoteText = eventDetail.description.isEmpty
              // ? 'Every journey towards family weaves new tales in the tapestry of our souls, binding us closer with each step.'
              // : eventDetail.description;
              final eventDetail = snapshot.data!;
              final DateTime? eventDate = DateTime.tryParse(eventDetail.date.trim());
              final DateTime now = DateTime.now();

              // 2. Compare year, month, and day safely
              final bool isToday = eventDate != null && eventDate.year == now.year &&
              eventDate.month == now.month && eventDate.day == now.day;
              final String currentQuoteText = isToday ? (eventDetail.description.isEmpty ? 'Every journey towards family weaves new tales in the tapestry of our souls, binding us closer with each step.'
              : eventDetail.description): '';
              
              final int randomSeed = currentQuoteText.hashCode;
              final int randomImageNum = (Random(randomSeed).nextInt(11)) + 1;
              final String prefix = isDarkMode ? 'db_' : 'wb_';
              final String currentBgPath = 'assets/ai_generated_img/$prefix$randomImageNum.png';

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 40.0.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomHeaderBar(
                      title: "Share Quote",
                      leftSpacing: 80,
                      rightSpacing: 80,
                      onBackPressed: () => context.go('/home'),
                    ),
                    SizedBox(height: 20.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Container(
                        width: 327.w,
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF0A1128) : Colors.white,
                          gradient: isDarkMode ? const LinearGradient(
                            colors: [Color(0xFF0A1128), Color(0xFF1A1F3A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                          image: DecorationImage(
                            image: AssetImage(currentBgPath),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: const Color(0xFFFFB703).withOpacity(0.4),
                            width: 1.w,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 24.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20.h,),
                              Text(
                                eventDetail.title.isEmpty ? 'Traveling to grandmother' : eventDetail.title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.playfair(
                                  fontSize: 27.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'Today • ${eventDetail.startTime.isEmpty ? "2:00 PM" : eventDetail.startTime}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? const Color(0xFF9CA3AF) : Colors.black,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1.h,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            const Color(0xFFFFB703).withOpacity(0.5)
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
                                      colorFilter: const ColorFilter.mode(
                                      Color(0xFFFFB703), BlendMode.srcIn),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1.h,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFFFFB703).withOpacity(0.5),
                                            Colors.transparent
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              RepaintBoundary(
                                key: eventController.quoteShareKey,
                                child: Text(
                                  currentQuoteText.isNotEmpty ? '“ $currentQuoteText ”': '',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cormorant(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode ? Colors.white: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Text(
                                'Inspired by InfiniQoute',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF4B5563),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: "Save",
                          onPressed: () async {
                            await eventController.shareQuoteAsImage(currentQuoteText, currentBgPath);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Quote saved as image!')),
                              );
                            }
                          },
                          borderGradient: AppGradientColors.button_gradient,
                          solidColor: isDarkMode ? AppColors.containers_bgd : AppColors.background_color,
                          textColor: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B),
                          fontFamily: 'outfit',
                          fontSize: 16.sp,
                          height: 48.h,
                          width: 159.w,
                          leadingIcon: SvgPicture.asset(
                            'assets/icons/download.svg',
                            width: 18.w,
                            height: 18.h,
                            colorFilter: ColorFilter.mode(
                              isDarkMode ? AppColors.text_color : const Color(0xFF373F4B),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        CustomButton(
                          text: "Share",
                          onPressed: () {
                            eventController.shareQuoteToSocialMedia(currentQuoteText, currentBgPath);
                          },
                          gradient: AppGradientColors.button_gradient,
                          textColor: AppColors.text_color,
                          fontFamily: 'outfit',
                          fontSize: 16.sp,
                          height: 48.h,
                          width: 159.w,
                          leadingIcon: SvgPicture.asset(
                            'assets/icons/share_filled.svg',
                            width: 18.w,
                            height: 18.h,
                            colorFilter: const ColorFilter.mode(
                              AppColors.text_color,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    TextButton(
                      onPressed: () => context.push('/all_events'),
                      child: Text(
                        'Explore more quotes  →',
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          color: isDarkMode ? AppColors.background_color : AppColors.heading_color,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildShimmerLoading(BuildContext context, bool isDarkMode) {
    final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 40.0.h),
      child: Column(
        children: [
          CustomHeaderBar(
            title: "Share Quote",
            leftSpacing: 80,
            rightSpacing: 80,
            onBackPressed: () => context.go('/home'),
          ),
          SizedBox(height: 20.h),
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 327.w,
              height: 420.h,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}