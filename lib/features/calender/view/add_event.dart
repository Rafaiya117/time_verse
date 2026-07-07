// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart' hide DatePickerDialog;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_bottomnav.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_date_picker.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/calender/controller/add_event_controller.dart';
import 'package:time_verse/features/calender/controller/calender_controller.dart';
import 'package:time_verse/features/calender/controller/time_controller.dart';
import 'package:time_verse/features/calender/widget/time_picker_custom_widget.dart';

class AddEventPage extends StatelessWidget {
  const AddEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final addEventController = Provider.of<AddEventController>(context, listen: false);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addEventController.fetchCategories();
    });

    const goldColor = Color(0xFFFFA500); 
    const inputBgColor = Color(0xFF0A192F); // Dark input card backgrounds

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeaderBar(
                  title: 'Add event',
                  leftSpacing: 90.w,
                  rightSpacing: 79.w,
                ),
                SizedBox(height: 20.h,),
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
                    // Expanded Input Text Field
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Event Name',
                            style: GoogleFonts.inter(
                              color: isDarkMode?Colors.white:Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          TextFormField(
                            controller: addEventController.titleController,
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
                    // Notebook with Pencil Emoji/Icon
                    Padding(
                      padding: EdgeInsets.only(top: 2.h, right: 12.w),
                      child: Text('📝', style: TextStyle(fontSize: 20.sp)),
                    ),
                    // Input Fields layout
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Add A Note',
                            style: GoogleFonts.inter(
                              color: isDarkMode?Colors.white: Colors.black, // Pure white matching the image layout
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          TextFormField(
                            controller: addEventController.noteController,
                            maxLines: 2,
                            style: GoogleFonts.inter(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 14.sp,
                            ),
                            cursorColor: const Color(0xFFFFA500),
                            decoration: InputDecoration(
                              hintText:'What would you like to Remember For This Special Moment?',
                              hintStyle: GoogleFonts.inter(
                                color: Colors.grey.shade500, // Matching the soft layout gray text
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
                        initialDate:Provider.of<CalendarController>(context,listen: false,).selectedDay ??
                         DateTime.now(),
                        isDarkMode: isDarkMode,
                      ),
                    );

                    if (pickedDate != null) {
                      String formattedDate = DateFormat('MMMM d, yyyy').format(pickedDate);
                      addEventController.dateController.text = formattedDate;
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
                              valueListenable:addEventController.dateController,
                              builder: (context, value, child) {
                                return Text(
                                  value.text.isEmpty? "Select Date": value.text,
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
                          textController: addEventController.startTimeController, // optional
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
                          textController: addEventController.endTimeController, // optional
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
                    // Red Location Pin Icon/Emoji
                    Padding(
                      padding: EdgeInsets.only(top: 2.h, right: 12.w),
                      child: Text('📍', style: TextStyle(fontSize: 18.sp)),
                    ),
                    // Input text block layout
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Where is this happening? (optional)',
                            style: GoogleFonts.inter(
                              color: isDarkMode?Colors.white: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          TextFormField(
                            controller: addEventController.locationController,
                            style: GoogleFonts.inter(
                              color: isDarkMode?Colors.white: Colors.black,
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
              _buildFormContainer(
                context,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h, right: 12.w),
                      child: Text('🔔', style: TextStyle(fontSize: 18.sp)),
                    ),
                    // Text block layout
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
                            '10 minutes before', 
                            style: GoogleFonts.inter(
                              color: isDarkMode? Colors.grey.shade500: Colors.grey.shade400,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              _buildFormContainer(
                context,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String selectedOption = 'Don\'t repeat'; 
                        return StatefulBuilder(
                          builder: (context, setModalState) {
                            Widget buildRadioRow(String label) {
                              final isCurrent = selectedOption == label;
                              return InkWell(
                                onTap: () {
                                  setModalState(() => selectedOption = label);
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
                              'Don\'t repeat', 
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
              ),
              SizedBox(height: 20.h),
              // --- SECTION: SELECT CATEGORY ---
              _buildSectionHeader('Select Category'),
              SizedBox(height: 12.h),
              
              Consumer<AddEventController>(
                builder: (context, controller, _) {
                  final categories = controller.categories;
                  if (categories.isEmpty) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.1,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) => _buildCategoryCardSkeleton(),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.1,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = controller.selectedCategory == category.name;

                      return GestureDetector(
                        onTap: () => controller.selectCategory(category.name),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w,), 
                          decoration: BoxDecoration(
                            color: isSelected? goldColor.withOpacity(0.15): (isDarkMode ? inputBgColor : Colors.white),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isSelected? goldColor: Colors.grey.shade800,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getCategoryIcon(category.name),
                                color: goldColor,
                                size: 24.sp,
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                category.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: isDarkMode? Colors.white: Colors.black,
                                  fontSize: 14.sp, 
                                  fontWeight: isSelected? FontWeight.w700: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 28.h),
              // --- SAVE BUTTON ---
              CustomButton(
                text: "Save",
                onPressed: () async {
                  final timeController = Provider.of<TimePickerController>(
                    context,
                    listen: false,
                  );
                  await addEventController.saveEvent(
                    context: context,
                    rawStart: timeController.formatTime(
                      timeController.getTime('start'),
                    ),
                    rawEnd: timeController.formatTime(
                      timeController.getTime('end'),
                    ),
                    rawAlarm: timeController.formatTime(
                      timeController.getTime('alarm'),
                    ),
                    onSuccess: () {},
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
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  // Visual framing encapsulation helpers matching iPhone layout standards
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        color: const Color(0xFFFFA500),
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFormContainer(BuildContext context,{required Widget child}) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    decoration: BoxDecoration(
      color: isDarkMode?const Color(0xFF041023):Colors.white, // Deep dark background matching the image
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: const Color(0xFFD4AF37).withOpacity(0.3), // Subtle gold border hue
        width: 1,
      ),
    ),
    child: child,
  );
}

  Widget _buildCategoryCardSkeleton() {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF0A192F),
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: Colors.grey.shade900),
    ),
    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
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

  // IconData _getCategoryIcon(String? name) {
  //   switch (name?.toLowerCase()) {
  //     case 'success stories': return Icons.emoji_events_outlined;
  //     case 'daily motivation': return Icons.wb_sunny_outlined;
  //     case 'personal growth': return Icons.trending_up;
  //     case 'workout': return Icons.fitness_center;
  //     default: return Icons.category_outlined;
  //   }
  // }
}

