// ignore_for_file: dead_null_aware_expression, deprecated_member_use

import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:time_verse/config/app_route/app_route.dart';
import 'package:time_verse/core/utils/colors.dart';

// class ExampleAlarmRingScreen extends StatefulWidget {
//   const ExampleAlarmRingScreen({required this.alarmSettings, super.key});

//   final AlarmSettings alarmSettings;

//   @override
//   State<ExampleAlarmRingScreen> createState() => _ExampleAlarmRingScreenState();
// }

// class _ExampleAlarmRingScreenState extends State<ExampleAlarmRingScreen> {
//   StreamSubscription<AlarmSet>? _subscription;

//   @override
//   void initState() {
//     super.initState();
//     debugPrint('********${widget.alarmSettings}********');
//     _subscription = Alarm.ringing.listen((alarms) {
//       if (alarms.containsId(widget.alarmSettings.id)) return;
//       if (mounted) Navigator.pop(context);
//     });
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final notification = widget.alarmSettings.notificationSettings;
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//            Text('Alarm ringing for ${notification.title ?? 'Alarm Ringing'}'),
//            Padding(
//              padding: const EdgeInsets.all(12.0),
//              child: Text(notification.body ?? ''),
//            ),
//             const Text('🔔', style: TextStyle(fontSize: 80)),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   onPressed: () async {
//                     await Alarm.set(
//                       alarmSettings: widget.alarmSettings.copyWith(
//                         dateTime: DateTime.now().add(
//                           const Duration(minutes: 1),
//                         ),
//                       ),
//                     );

//                     if (!mounted) return;
//                     appRouter.go('/'); // 👈 REQUIRED
//                   },
//                   child: const Text('SNOOZE'),
//                 ),

//                 ElevatedButton(
//                   onPressed: () async {
//                     await Alarm.stop(widget.alarmSettings.id);
//                     if (!mounted) return;
//                     appRouter.go('/');
//                   },
//                   child: const Text('STOP'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ExampleAlarmRingScreen extends StatefulWidget {
  const ExampleAlarmRingScreen({required this.alarmSettings, super.key});

  final AlarmSettings alarmSettings;

  @override
  State<ExampleAlarmRingScreen> createState() => _ExampleAlarmRingScreenState();
}

class _ExampleAlarmRingScreenState extends State<ExampleAlarmRingScreen> {
  StreamSubscription<AlarmSet>? _subscription;

  @override
  void initState() {
    super.initState();
    debugPrint('********${widget.alarmSettings}********');
    _subscription = Alarm.ringing.listen((alarms) {
      if (alarms.containsId(widget.alarmSettings.id)) return;
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notification = widget.alarmSettings.notificationSettings;
    final String formattedTime = DateFormat('HH:mm').format(widget.alarmSettings.dateTime);
    final String formattedDateStr = DateFormat('EEE d MMMM').format(widget.alarmSettings.dateTime);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    // Bell Header Icon
                    Icon(
                      Icons.notifications_active,
                      color: const Color(0xFFFFB703),
                      size: 56.sp,
                    ),
                    SizedBox(height: 12.h),
                    // Subtitle Title Text Layer
                    Text(
                      'ALARM RINGING FOR',
                      style: GoogleFonts.cormorant(
                        color: const Color(0xFFFFB703),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 5.5,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Heading Main dynamic Title
                    Text(
                      notification.title ?? 'Alarm Ringing',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        color: isDarkMode?AppColors.button_color:Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Divider graphics accent pattern with a single bright central diamond asset
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 40.w, height: 1.h, color: Colors.white24),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Icon(Icons.star, color: const Color(0xFFFFB703), size: 12.sp),
                        ),
                        Container(width: 40.w, height: 1.h, color: Colors.white24),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // Big Clock Render digits text stack block element
                    Text(
                      formattedTime,
                      style: GoogleFonts.playfairDisplay(
                        color: const Color(0xFFFF9F1C),
                        fontSize: 68.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Date element tag layer display row item properties
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('📅 ', style: TextStyle(fontSize: 14.sp)),
                        Text(
                          'Today  •  $formattedDateStr',
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade400,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    // Context description element details card component box
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                      decoration: BoxDecoration(
                        color:  isDarkMode?Color(0xFF041124):Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '“',
                            style: GoogleFonts.cormorant(
                              color: const Color(0xFFFFB703),
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            notification.body ?? 'Every journey leads ahead, stepping into the potential trapped beneath your dreams.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cormorant(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 23.sp,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24.h), 
                    Container(
                      width: 90.w,
                      height: 90.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFB703).withOpacity(0.12),
                        border: Border.all(
                          color: const Color(0xFFFFB703).withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFB703).withOpacity(0.25),
                            blurRadius: 35,
                            spreadRadius: 12,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 70.w,
                          height: 70.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFB703).withOpacity(0.18),
                            border: Border.all(
                              color: const Color(0xFFFFB703).withOpacity(0.35),
                              width: 1.2,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 54.w,
                              height: 54.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFFFB703).withOpacity(0.3),
                              ),
                              child: Icon(
                                Icons.notifications,
                                color: const Color(0xFFFFB703),
                                size: 28.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h), 
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50.h,
                            child: OutlinedButton(
                              onPressed: () async {
                                await Alarm.set(
                                  alarmSettings: widget.alarmSettings.copyWith(
                                    dateTime: DateTime.now().add(
                                      const Duration(minutes: 1),
                                    ),
                                  ),
                                );
                                if (!mounted) return;
                                appRouter.go('/home');
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isDarkMode ? Colors.white30 : const Color(0xFFFFB800),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '😴 ',
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  Text(
                                    'Snooze',
                                    style: GoogleFonts.inter(
                                      // 🛠️ FIX 2: Set text color to golden when it is not dark mode
                                      color: isDarkMode ? Colors.white: const Color(0xFFFFB800),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: SizedBox(
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: () async {
                                await Alarm.stop(widget.alarmSettings.id);
                                if (!mounted) return;
                                appRouter.go('/home');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE6A100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.stop, color: Colors.black, size: 18.sp),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'Stop',
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white38, size: 20.sp),
                        Text(
                          'Swipe Up to dismiss',
                          style: GoogleFonts.inter(
                            color: Colors.white38,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}