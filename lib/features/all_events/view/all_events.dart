import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_bottomnav.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/all_events/controller/all_events.dart';
import 'package:time_verse/features/all_events/custom_widget/custom_eventcard.dart';
import 'package:time_verse/features/all_events/custom_widget/event_remove_modal.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';

class AllEvents extends StatelessWidget {
  const AllEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final location = GoRouterState.of(context).uri.toString();
    final controller = Provider.of<AllEventsController>(context, listen: false);
    controller.updateIndexFromRoute(location);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchEvents();
    });
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 32.h),
        child: Column(
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
                  'All Events',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: isDarkMode? AppColors.text_color: AppColors.heading_color,
                  ),
                ),
                SizedBox(width: 70.w,),
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
            Consumer<AllEventsController>(
              builder: (context, controller, _) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.events.length,
                    itemBuilder: (context, index) {
                      final EventModel event = controller.events[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom:20.0),
                        child: EventCard(
                          title: event.title,
                          date: event.date,
                          time: event.time,
                          location: event.location,
                          isDarkMode: isDarkMode,
                          onDelete: () =>controller.confirmAndRemoveEvent(context, index)
                          //controller.removeEvent(index),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            // SizedBox(height: 10.h),
            //   Center(
            //     child: CustomButton(
            //       text: "Add New Event",
            //       onPressed: () {
            //         //context.push('/signup');
            //         context.push('/add');
            //       },
            //       gradient: AppGradientColors.button_gradient,
            //       textColor: AppColors.text_color,
            //       fontFamily: 'outfit',
            //       fontSize: 16.sp,
            //       fontWeight: FontWeight.normal,
            //       height: 51.h,
            //       width: double.infinity,
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar:Consumer<AllEventsController>(
        builder: (context, controller, _) => CustomBottomNavBar(),
      ),
    );
  }
}