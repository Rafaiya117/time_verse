import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_bottomnav.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/all_events/custom_widget/custom_eventcard.dart';
import 'package:time_verse/features/all_events/custom_widget/event_remove_modal.dart';
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
      extendBody: true,
      body: SafeArea(
        bottom: false, 
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. App Header Configuration
              CustomHeaderBar(
                title: 'My Calender',
                leftSpacing: 80.w,
                rightSpacing: 57.w,
              ),
              SizedBox(height: 16.h),
              
              // 2. Main Premium Calendar Widget Layer
              FancyCalendarView(),
              SizedBox(height: 28.h),
              
              // 3. Upcoming Events Section Title Bar with "View all" Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Events',
                    style: GoogleFonts.playfairDisplay(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                      color: AppColors.fourth_color,
                    ),
                  ),
                  // "View all" action item sitting nicely on the right side
                  GestureDetector(
                    onTap: () {
                      context.push('/all_events');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFA500).withOpacity(0.1),
                        border: Border.all(
                          color: const Color(0xFFFFA500), // Subtle dark outline border decoration
                          width: 0.7,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View all',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFFFA500), // Matching premium gold theme tone
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.arrow_forward,
                            size: 12.sp,
                            color: const Color(0xFFFFA500), // Tiny arrow asset matching layout spec
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              
              // 4. Dynamic Event Cards List
              Consumer<CalendarController>(
                builder: (context, controller, _) {
                  if (controller.events.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return ListView.builder(
                    shrinkWrap: true, 
                    physics: const NeverScrollableScrollPhysics(),  
                    itemCount: controller.events.length,
                    itemBuilder: (context, index) {
                      final EventModel event = controller.events[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.0.h),
                        child: EventCard(
                          id: event.id,
                          title: event.title,
                          sub_title: event.description,
                          date: event.date,
                          time: '${event.startTime}-${event.endTime}',
                          location: event.location,
                          isDarkMode: isDarkMode,
                          onDelete: () async {
                            showRemoveEventDialog(
                                context,
                                onConfirm: () async {
                                  final success = await controller.runWithLoaderAndTimer(
                                    context: context,
                                    task: () => controller.removeEventFromList(event.id),);
                                  if (success != true) {
                                    debugPrint('❌ Failed to delete event');
                                }
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}