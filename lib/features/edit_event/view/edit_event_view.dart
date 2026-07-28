import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_date_picker.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/features/calender/widget/time_picker_custom_widget.dart';
import 'package:time_verse/features/edit_event/controller/edit_event_controller.dart';

class EditEventPage extends StatelessWidget {
  final String eventId;

  const EditEventPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    // Trigger initialization once the frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<EditEventController>();
      if (controller.isLoading) {
        controller.initEditPage(eventId);
      }
    });

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final controller = context.watch<EditEventController>();
    const goldColor = Color(0xFFFFA500);

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator(color: goldColor))
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomHeaderBar(
                      title: 'Edit Event',
                      leftSpacing: 90.w,
                      rightSpacing: 79.w,
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
                                  controller: controller.titleController,
                                  style: GoogleFonts.inter(
                                    color: isDarkMode ? Colors.white : Colors.black,
                                    fontSize: 14.sp,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. Morning Meditation',
                                    hintStyle: GoogleFonts.inter(
                                      color: Colors.grey.shade500,
                                      fontSize: 13.sp,
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
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
                                  'Note',
                                  style: GoogleFonts.inter(
                                    color: isDarkMode ? Colors.white : Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                TextFormField(
                                  controller: controller.noteController,
                                  maxLines: 2,
                                  style: GoogleFonts.inter(
                                    color: isDarkMode ? Colors.white : Colors.black,
                                    fontSize: 14.sp,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Add notes or details',
                                    hintStyle: GoogleFonts.inter(
                                      color: Colors.grey.shade500,
                                      fontSize: 13.sp,
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
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
                            builder: (context) => CustomDatePickerDialog(
                              initialDate: DateTime.now(),
                              isDarkMode: isDarkMode,
                            ),
                          );

                          if (pickedDate != null) {
                            controller.dateController.text = DateFormat('MMMM d, yyyy').format(pickedDate);
                          }
                        },
                        child: Row(
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
                                    valueListenable: controller.dateController,
                                    builder: (context, value, _) {
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
                              color: goldColor,
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
                            child: TimePickerField(
                              fieldKey: 'start',
                              label: 'Start Time',
                              textController: controller.startTimeController,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildFormContainer(
                            context,
                            child: TimePickerField(
                              fieldKey: 'end',
                              label: 'End Time',
                              textController: controller.endTimeController,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // --- SECTION: ALARM & REPEAT ---
                    _buildSectionHeader('Options'),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        // --- REMINDER / ALARM ---
                        Expanded(
                          child: _buildFormContainer(
                            context,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: Icon(
                                    Icons.notifications_none_rounded,
                                    color: goldColor,
                                    size: 20.sp,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Reminder',
                                        style: GoogleFonts.inter(
                                          color: isDarkMode ? Colors.white : Colors.black,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: controller.selectedReminder,
                                          isDense: true,
                                          isExpanded: true,
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: goldColor,
                                            size: 18.sp,
                                          ),
                                          dropdownColor: isDarkMode ? const Color(0xFF131B26) : Colors.white,
                                          style: GoogleFonts.inter(
                                            color: isDarkMode ? Colors.white70 : Colors.black87,
                                            fontSize: 12.sp,
                                          ),
                                          items: controller.reminderOptions.map((option) => DropdownMenuItem<String>(
                                            value: option,
                                            child: Text(option),
                                          )).toList(),
                                          onChanged: (val) {
                                            if (val != null) controller.selectReminder(val);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),

                        // --- REPEAT ---
                        Expanded(
                          child: _buildFormContainer(
                            context,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: Icon(
                                    Icons.repeat_rounded,
                                    color: goldColor,
                                    size: 20.sp,
                                  ),
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
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: controller.selectedRepeat,
                                          isDense: true,
                                          isExpanded: true,
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: goldColor,
                                            size: 18.sp,
                                          ),
                                          dropdownColor: isDarkMode ? const Color(0xFF131B26) : Colors.white,
                                          style: GoogleFonts.inter(
                                            color: isDarkMode ? Colors.white70 : Colors.black87,
                                            fontSize: 12.sp,
                                          ),
                                          items: controller.repeatOptions.map((option) => DropdownMenuItem<String>(
                                            value: option,
                                            child: Text(option),
                                          )).toList(),
                                          onChanged: (val) {
                                            if (val != null) controller.selectRepeat(val);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // --- SECTION: CATEGORY SELECTOR ---
                    _buildSectionHeader('Select Category'),
                    SizedBox(height: 12.h),
                    _buildModernCategoryList(context, controller, isDarkMode),

                    SizedBox(height: 30.h),

                    // --- SAVE BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        onPressed: () async {
                          final success = await controller.updateEvent(eventId);
                          if (success && context.mounted) Navigator.pop(context);
                        },
                        child: Text(
                          'Update Event',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildModernCategoryList(
    BuildContext context,
    EditEventController controller,
    bool isDarkMode,
  ) {
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
                      color: isSelected
                          ? accentColor.withOpacity(0.15)
                          : (isDarkMode ? const Color(0xFF131B26) : Colors.grey.shade100),
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
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? accentColor
                                : (isDarkMode ? const Color(0xFF1E293B) : Colors.white),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getCategoryIcon(category.name),
                            size: 20.sp,
                            color: isSelected
                                ? Colors.black
                                : (isDarkMode ? Colors.white70 : Colors.black87),
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
                            color: isSelected
                                ? accentColor
                                : (isDarkMode ? Colors.white70 : Colors.black87),
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
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0A192F)
            : Colors.grey.shade100,
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