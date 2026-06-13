import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/core/components/custom_header.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/mountain_bg.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     // ignore: deprecated_member_use
                //     const Color(0xFF020813).withOpacity(0.95), 
                //     // ignore: deprecated_member_use
                //     const Color(0xFF0A1120).withOpacity(0.85),
                //     // ignore: deprecated_member_use
                //     const Color(0xFF0D1527).withOpacity(0.40), 
                //   ],
                // ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                CustomHeaderBar(
                  title: 'Notification',
                  leftSpacing: 90.w,
                  rightSpacing: 79.w,
                ),
                SizedBox(height: 24.h),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    children: [
                      const NotificationCard(
                        title: 'Reminder Scheduled',
                        description: 'Your mindfulness reminder has been scheduled for tonight.',
                        iconWidget: CustomCalendarIcon(),
                      ),
                      SizedBox(height: 16.h),
                      const NotificationCard(
                        title: 'Premium Activated',
                        description: 'Your premium membership has been successfully activated.',
                        iconWidget: CustomDollarIcon(),
                      ),
                      SizedBox(height: 16.h),
                      const NotificationCard(
                        title: 'New AI Wisdom Generated',
                        description: 'Your personalized cosmic quote is ready to explore and save.',
                        iconWidget: CustomSparkIcon(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget iconWidget;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: const Color(0xFF091222).withOpacity(0.85),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          // ignore: deprecated_member_use
          color: const Color(0xFFFFB703).withOpacity(0.3),
          width: 1.1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconWidget,
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  description,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                    color: const Color(0xFF9CA3AF), // Clean neutral ash tone text body
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: - Specialized Icon Components

class CustomCalendarIcon extends StatelessWidget {
  const CustomCalendarIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom modern minimal Calendar block graphic
    return Container(
      width: 28.w,
      height: 28.h,
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB).withOpacity(0.2),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Icon(Icons.calendar_month, color: const Color(0xFF60A5FA), size: 18.sp),
    );
  }
}

class CustomDollarIcon extends StatelessWidget {
  const CustomDollarIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28.w,
      height: 28.h,
      child: Center(
        child: Text(
          '\$',
          style: GoogleFonts.outfit(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFB703), // Matching direct amber accent color spec
          ),
        ),
      ),
    );
  }
}

class CustomSparkIcon extends StatelessWidget {
  const CustomSparkIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28.w,
      height: 28.h,
      child: Center(
        child: Icon(
          Icons.start,
          color: const Color(0xFFFFB703), // Cosmic four-point star accent
          size: 20.sp,
        ),
      ),
    );
  }
}

// MARK: - Structural Design Dividers

class GradientDivider extends StatelessWidget {
  final bool isLeft;
  const GradientDivider({super.key, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLeft
              ? [Colors.transparent, const Color(0xFFFFB703).withOpacity(0.5)]
              : [const Color(0xFFFFB703).withOpacity(0.5), Colors.transparent],
        ),
      ),
    );
  }
}