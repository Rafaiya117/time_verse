// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_date_picker.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/calender/controller/calender_controller.dart';
import 'package:time_verse/features/calender/controller/time_controller.dart';
import 'package:time_verse/features/calender/widget/time_picker_custom_widget.dart';
import 'package:time_verse/features/edit_event/controller/edit_event_controller.dart';

class EditEventPage extends StatelessWidget {
  final String eventId;

  const EditEventPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final editEventController = Provider.of<EditEventController>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      editEventController.initEditPage(eventId);

      final state = GoRouterState.of(context);
      final passingDate = state.uri.queryParameters['selectedDate'];
      if (passingDate != null && passingDate.isNotEmpty) {
        editEventController.dateController.text = passingDate;
      }
    });
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeaderBar(
                title: 'Edit event',
                leftSpacing: 80.w,
                rightSpacing: 69.w,
              ),
              SizedBox(height: 20.h),

              // --- SECTION: BASICS ---
              _buildSectionHeader('Basics'),
              SizedBox(height: 8.h),
              _buildFormContainer(
                context,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h, right: 12.w),
                      child: SvgPicture.asset(
                        'assets/icons/sparkle.svg',
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Event Name',
                            style: GoogleFonts.inter(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          TextFormField(
                            controller: editEventController.titleController,
                            style: GoogleFonts.inter(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g. morning Meditation',
                              hintStyle: GoogleFonts.inter(
                                color: Colors.grey.shade500,
                                fontSize: 13.sp,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              _buildFormContainer(
                context,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h, right: 12.w),
                      child: Text('📝', style: TextStyle(fontSize: 20.sp)),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Add A Note',
                            style: GoogleFonts.inter(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          TextFormField(
                            controller: editEventController.noteController,
                            maxLines: 2,
                            style: GoogleFonts.inter(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 14.sp,
                            ),
                            cursorColor: const Color(0xFFFFA500),
                            decoration: InputDecoration(
                              hintText: 'What would you like to Remember For This Special Moment?',
                              hintStyle: GoogleFonts.inter(
                                color: Colors.grey.shade500,
                                fontSize: 13.sp,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // --- SECTION: SCHEDULE ---
              _buildSectionHeader('Schedule'),
              SizedBox(height: 8.h),
              _buildFormContainer(
                context,
                child: GestureDetector(
                  onTap: () async {
                    final DateTime? pickedDate = await showDialog<DateTime>(
                      context: context,
                      builder: (BuildContext context) => CustomDatePickerDialog(
                        initialDate: Provider.of<CalendarController>(context, listen: false).selectedDay ?? DateTime.now(),
                        isDarkMode: isDarkMode,
                      ),
                    );

                    if (pickedDate != null) {
                      String formattedDate = DateFormat('MMMM d, yyyy').format(pickedDate);
                      editEventController.dateController.text = formattedDate;
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: SvgPicture.asset(
                          'assets/icons/calender_2.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Date',
                              style: GoogleFonts.inter(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: editEventController.dateController,
                              builder: (context, value, child) {
                                return Text(
                                  value.text.isEmpty ? "Select Date" : value.text,
                                  style: GoogleFonts.inter(
                                    color: isDarkMode ? Colors.white : Colors.black,
                                    fontSize: 13.sp,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: const Color(0xFFFFA500),
                        size: 22.sp,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _buildFormContainer(
                      context,
                      child: Consumer<TimePickerController>(
                        builder: (context, controller, _) => TimePickerField(
                          fieldKey: 'start',
                          label: 'Start Time',
                          textController: editEventController.startTimeController,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildFormContainer(
                      context,
                      child: Consumer<TimePickerController>(
                        builder: (context, controller, _) => TimePickerField(
                          fieldKey: 'end',
                          label: 'End Time',
                          textController: editEventController.endTimeController,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // --- SECTION: DETAILS ---
              _buildSectionHeader('Details'),
              SizedBox(height: 8.h),
              _buildFormContainer(
                context,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h, right: 12.w),
                      child: Text('📍', style: TextStyle(fontSize: 18.sp)),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Where is this happening? (optional)',
                            style: GoogleFonts.inter(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          TextFormField(
                            controller: editEventController.locationController,
                            style: GoogleFonts.inter(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Add address or location',
                              hintStyle: GoogleFonts.inter(
                                color: Colors.grey.shade500,
                                fontSize: 13.sp,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Consumer<TimePickerController>(
                builder: (context, timeController, _) {
                  final selectedReminderOption = timeController.selectedReminderOption;
                  final options = ['5 min before', '10 min before', '30 min before', '1 hr before'];

                  return PopupMenuButton<String>(
                    onSelected: (option) {
                      timeController.setReminderOption(option);
                    },
                    color: isDarkMode ? const Color(0xFF131B26) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    offset: Offset(0, 50.h),
                    itemBuilder: (context) => options.map((option) {
                      final isSelected = option == selectedReminderOption;
                      return PopupMenuItem<String>(
                        value: option,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              option,
                              style: GoogleFonts.inter(
                                color: isSelected ? const Color(0xFFFFB703) : (isDarkMode ? Colors.white : Colors.black),
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_rounded,
                                color: const Color(0xFFFFB703),
                                size: 18.sp,
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    child: _buildFormContainer(
                      context,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2.h, right: 12.w),
                            child: Text(
                              '🔔',
                              style: TextStyle(fontSize: 18.sp),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Remind me',
                                  style: GoogleFonts.inter(
                                    color: isDarkMode ? Colors.white : Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  selectedReminderOption,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFFFB703),
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 12.h),
              Consumer<EditEventController>(
                builder: (context, controller, _) {
                  final currentRepeat = controller.selectedRepeat ?? "Don't repeat";

                  return _buildFormContainer(
                    context,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                Widget buildRadioRow(String label) {
                                  final isCurrent = (controller.selectedRepeat ?? "Don't repeat") == label;
                                  return InkWell(
                                    onTap: () {
                                      controller.setSelectedRepeat(label);
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20.w,
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isCurrent ? const Color(0xFF2F80ED) : Colors.grey.shade600,
                                                width: isCurrent ? 6 : 2,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 16.w),
                                          Text(
                                            label,
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                return Dialog(
                                  backgroundColor: const Color(0xFF15181F),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                                  insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                                  child: Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Repeat',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          'This event doesn\'t repeat.',
                                          style: GoogleFonts.inter(
                                            color: Colors.grey.shade400,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        buildRadioRow('Don\'t repeat'),
                                        Divider(color: Colors.grey.shade800, height: 1),
                                        buildRadioRow('Every 1 day'),
                                        Divider(color: Colors.grey.shade800, height: 1),
                                        buildRadioRow('Every 1 week'),
                                        Divider(color: Colors.grey.shade800, height: 1),
                                        buildRadioRow('Every 1 month'),
                                        Divider(color: Colors.grey.shade800, height: 1),
                                        buildRadioRow('Every 1 year'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2.h, right: 12.w),
                            child: Text('🔁', style: TextStyle(fontSize: 18.sp)),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Repeat',
                                  style: GoogleFonts.inter(
                                    color: isDarkMode ? Colors.white : Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  currentRepeat,
                                  style: GoogleFonts.inter(
                                    color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: const Color(0xFFFFA500),
                            size: 22.sp,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h),

              // --- SECTION: SELECT CATEGORY ---
              _buildSectionHeader('Select Category'),
              SizedBox(height: 12.h),

              // Custom Category Builder
              _buildModernCategoryList(
                context,
                editEventController,
                isDarkMode,
              ),

              SizedBox(height: 28.h),

              // --- UPDATE BUTTON ---
              CustomButton(
                text: "Update",
                onPressed: () async {
                  final timeController = Provider.of<TimePickerController>(
                    context,
                    listen: false,
                  );

                  await editEventController.updateEvent(
                    context: context,
                    eventId: eventId,
                    rawStart: timeController.formatTime(
                      timeController.getTime('start'),
                    ),
                    rawEnd: timeController.formatTime(
                      timeController.getTime('end'),
                    ),
                    rawAlarm: timeController.formatTime(
                      timeController.getTime('alarm'),
                    ),
                    onSuccess: () {
                      if (context.mounted) {
                        context.go('/home'); 
                      }
                    },
                  );
                },
                gradient: AppGradientColors.button_gradient,
                textColor: AppColors.text_color,
                fontFamily: 'outfit',
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                height: 51.h,
                width: double.infinity,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildModernCategoryList(BuildContext context,EditEventController controller,bool isDarkMode,) {
    const accentColor = Color(0xFFFFA500);

    return SizedBox(
      height: 90.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          final isSelected = controller.selectedCategory == category.name;

          return Padding(
            padding: EdgeInsets.only(right: 12.w, top: 4.h),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: () => controller.selectCategory(category.name),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected? accentColor.withOpacity(0.15): (isDarkMode ? const Color(0xFF131B26) : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isSelected ? accentColor : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                      ? [
                        BoxShadow(
                          color: accentColor.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]: [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: isSelected ? accentColor : (isDarkMode ? const Color(0xFF1E293B) : Colors.white),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getCategoryIcon(category.name),
                            size: 20.sp,
                            color: isSelected ? Colors.black: (isDarkMode ? Colors.white70 : Colors.black87),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          category.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? accentColor : (isDarkMode ? Colors.white70 : Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildFormContainer(BuildContext context, {required Widget child}) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF0A192F): Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }

  IconData _getCategoryIcon(String? name) {
    switch (name?.toLowerCase().trim()) {
      case 'success stories':
        return Icons.emoji_events_outlined;
      case 'daily motivation':
      case 'motivation':
        return Icons.wb_sunny_outlined;
      case 'self improvement':
        return Icons.trending_up_rounded;
      case 'career focused':
        return Icons.work_outline_rounded;
      case 'love & relationship':
        return Icons.favorite_border_rounded;
      case 'education':
        return Icons.school_outlined;
      case 'health':
        return Icons.health_and_safety_outlined;
      case 'finance':
        return Icons.account_balance_wallet_outlined;
      case 'mindfulness':
        return Icons.spa_outlined;
      case 'productivity':
        return Icons.bolt_rounded;
      default:
        return Icons.category_outlined;
    }
  }
}