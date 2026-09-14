import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/bottom_card_controller/bottom_card_controller.dart';
import 'package:time_verse/core/components/custom_bottomnav.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/features/all_events/controller/all_events.dart';
import 'package:time_verse/features/all_events/custom_widget/custom_eventcard.dart';
import 'package:time_verse/features/all_events/custom_widget/event_remove_modal.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';

class AllEvents extends StatelessWidget {
  const AllEvents({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);
    final location = GoRouterState.of(context).uri.toString();
    final controller = Provider.of<AllEventsController>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllEvents();
      context.read<BottomNavController>().updateIndexFromRoute(location);
    });
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 40.h),
        child: Column(
          children: [
            CustomHeaderBar(
              title: 'All Events', 
              leftSpacing: 100, 
              rightSpacing: 70
            ),
            //SizedBox(height: 20.h,),
            Consumer<AllEventsController>(
              builder: (context, controller, _) {
                final now = DateTime.now();
                final todayEvents = controller.events.where((e) {
                  DateTime? parsedDate = DateTime.tryParse(e.createdAt);
                  if (parsedDate == null && e.date.isNotEmpty) {
                    try {
                      parsedDate = DateFormat('EEEE, MMM d, yyyy').parse(e.date);
                    } catch (_) {}
                  }
                  if (parsedDate == null) return false;
                    return parsedDate.year == now.year && parsedDate.month == now.month && parsedDate.day == now.day;
                  }).toList().reversed.toList();

                  return Expanded(
                    child: ListView.builder(
                      itemCount: todayEvents.length,
                      itemBuilder: (context, index) {
                      final EventModel event = todayEvents[index];

                      // Parse event date to verify if it is today
                      DateTime? parsedDate = DateTime.tryParse(event.createdAt);
                      if (parsedDate == null && event.date.isNotEmpty) {
                        try {
                          parsedDate = DateFormat('EEEE, MMM d, yyyy',).parse(event.date);
                        } catch (_) {}
                      }
                      final bool isToday = parsedDate != null && parsedDate.year == now.year && parsedDate.month == now.month && parsedDate.day == now.day;
                      return Dismissible(
                        key: ValueKey(event.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          final completer = Completer<bool>();
                          showRemoveEventDialog(
                            context,
                            onConfirm: () {
                              controller.runWithLoaderAndTimer<bool>(
                                context: context,
                                task: () => controller.removeEventFromList(
                                  event,
                                  deleteType: 'single',
                                ),
                              ).then((success) {
                                if (success != true) {
                                  debugPrint('❌ Failed to delete event');
                                }
                                completer.complete(success == true);
                              });
                            },
                          );
                          return await completer.future.catchError(
                            (_) => false,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: EventCard(
                            id: event.id,
                            title: event.title,
                            // Show sub_title ONLY if the event is today
                            sub_title: isToday ? event.description : '',
                            date: event.date,
                            time: '${event.startTime}-${event.endTime}',
                            location: event.category == 'Google Calendar'? '': event.location,
                            isDarkMode: isDarkMode,
                            onEdit: () {
                              context.push('/edit_event', extra: event);
                            },
                            onDelete: () {
                              showRemoveEventDialog(
                                context,
                                onConfirm: () {
                                  controller.runWithLoaderAndTimer<bool>(
                                  context: context,
                                  task: () => controller.removeEventFromList(
                                    event,
                                    deleteType: 'single',
                                    ),
                                  ).then((success) {
                                  if (success != true) {
                                    debugPrint('❌ Failed to delete event');
                                    }
                                  });
                                },
                              );
                            },
                          ),
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
      bottomNavigationBar:Consumer<AllEventsController>(
        builder: (context, controller, _) => CustomBottomNavBar(),
      ),
    );
  }
}

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