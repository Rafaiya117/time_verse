import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_bottomnav.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/all_events/custom_widget/custom_eventcard.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/calender/controller/calender_controller.dart';
import 'package:time_verse/features/calender/widget/custom_calender_widget.dart';

class CalenderView extends StatelessWidget {
  const CalenderView({super.key});
 @override
Widget build(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final controller = Provider.of<CalendarController>(context, listen: false);
  WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchUpcomingEvents();
    });
  return Scaffold(
    body: Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 32.0.h),
          child: Column(
            children: [
              CustomHeaderBar(
                title: 'My Calendar',
                leftSpacing: 80.w,
                rightSpacing: 70.w,
              ),
              FancyCalendarView(),
              SizedBox(height: 24.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Upcoming Events',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: isDarkMode
                      ? AppColors.text_color
                      : AppColors.heading_color,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Consumer<CalendarController>(
                builder: (context, controller, _) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: controller.events.length,
                      itemBuilder: (context, index) {
                        final EventModel event = controller.events[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: EventCard(
                            title: event.title,
                            date: event.date,
                            time: '${event.startTime}-${event.endTime}',
                            location: event.location,
                            isDarkMode: isDarkMode,
                            onDelete: () => controller.removeEvent(index),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
    bottomNavigationBar: const CustomBottomNavBar(),
  );
}
}