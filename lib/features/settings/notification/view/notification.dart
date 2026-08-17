// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/features/settings/notification/controller/notification_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NotificationSettingsController>();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                CustomHeaderBar(
                  title: 'Notification Settings',
                  leftSpacing: 60.w,
                  rightSpacing: 50.w,
                ),
                SizedBox(height: 24.h),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    children: [
                      // --- MAIN ALERTS TOGGLES ---
                      _buildSectionTitle('Alert Preferences'),
                      SizedBox(height: 12.h),
                      _buildSwitchTile(
                        context: context,
                        title: 'Allow Notifications',
                        subtitle: 'Receive push & event reminder alerts',
                        value: controller.allowNotifications,
                        icon: Icons.notifications_active_outlined,
                        onChanged: controller.setAllowNotifications,
                      ),
                      SizedBox(height: 12.h),
                      _buildSnoozeDurationTile(context: context),
                      SizedBox(height: 12.h),
                      _buildSwitchTile(
                        context: context,
                        title: 'Allow Alarms',
                        subtitle: 'Trigger full screen exact time alarms',
                        value: controller.allowAlarms,
                        icon: Icons.alarm,
                        onChanged: controller.setAllowAlarms,
                      ),
                      SizedBox(height: 12.h),
                      _buildSwitchTile(
                        context: context,
                        title: 'Vibration',
                        subtitle: 'Vibrate on alarms and notifications',
                        value: controller.vibrate,
                        icon: Icons.vibration,
                        onChanged: controller.setVibrate,
                      ),

                      SizedBox(height: 24.h),

                      // --- VOLUME CONTROL SLIDERS ---
                      _buildSectionTitle('Audio Volume'),
                      SizedBox(height: 12.h),
                      _buildSliderTile(
                        context: context,
                        title: 'Notification Volume',
                        value: controller.notificationVolume,
                        icon: Icons.volume_down_outlined,
                        onChanged: controller.setNotificationVolume,
                      ),
                      SizedBox(height: 12.h),
                      _buildSliderTile(
                        context: context,
                        title: 'Alarm Volume',
                        value: controller.alarmVolume,
                        icon: Icons.alarm_add_sharp,
                        onChanged: controller.setAlarmVolume,
                      ),

                      SizedBox(height: 24.h),

                      // --- SOUND SELECTION ---
                      _buildSectionTitle('Sound Profile'),
                      SizedBox(height: 12.h),
                      _buildRingtoneSelector(context: context),
                      SizedBox(height: 24.h),
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

  // Section Header Text Helper
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFFFB703),
      ),
    );
  }

  // Switch Settings Item Card
  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF091222).withOpacity(0.85) : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFFFB703).withOpacity(0.3),
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFB703), size: 22.sp),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFFFFB703),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // Volume Slider Settings Item Card
  Widget _buildSliderTile({
    required BuildContext context,
    required String title,
    required double value,
    required IconData icon,
    required ValueChanged<double> onChanged,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF091222).withOpacity(0.85) : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFFFB703).withOpacity(0.3),
          width: 1.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFFFB703), size: 20.sp),
              SizedBox(width: 12.w),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                '${(value * 100).toInt()}%',
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.r),
            ),
            child: Slider(
              value: value,
              activeColor: const Color(0xFFFFB703),
              inactiveColor: const Color(0xFF9CA3AF).withOpacity(0.3),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  // Sound Picker Selector Card
  Widget _buildRingtoneSelector({required BuildContext context}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final controller = context.read<NotificationSettingsController>();

    return InkWell(
      onTap: () => controller.openDeviceSoundSettings(),
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF091222).withOpacity(0.85)
              : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: const Color(0xFFFFB703).withOpacity(0.3),
            width: 1.1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.music_note, color: const Color(0xFFFFB703), size: 22.sp),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alarm Sound',
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Configure in Device Settings',
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.open_in_new,
              color: const Color(0xFFFFB703),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSnoozeDurationTile({required BuildContext context}) {
    final controller = context.watch<NotificationSettingsController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF091222).withOpacity(0.85): Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFFFB703).withOpacity(0.3),
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.snooze, color: const Color(0xFFFFB703), size: 22.sp),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Snooze Duration',
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Delay duration when snoozing an alarm',
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: controller.snoozeDurationMinutes,
              dropdownColor: isDarkMode ? const Color(0xFF091222): Colors.white,
              icon: Icon(
                Icons.arrow_drop_down,
                color: const Color(0xFFFFB703),
                size: 22.sp,
              ),
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFFB703),
              ),
              items: [5, 10, 15, 20, 30].map((int minutes) {
                return DropdownMenuItem<int>(
                  value: minutes,
                  child: Text('$minutes min'),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  controller.setSnoozeDuration(val);
                }
              },
            ),
          ),
        ],
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
          colors: isLeft ? [Colors.transparent, const Color(0xFFFFB703).withOpacity(0.5)]: [const Color(0xFFFFB703).withOpacity(0.5), Colors.transparent],
        ),
      ),
    );
  }
}