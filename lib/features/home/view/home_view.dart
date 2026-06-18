// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/core/components/bottom_card_controller/bottom_card_controller.dart';
import 'package:time_verse/core/components/custom_bottomnav.dart';
import 'package:time_verse/core/components/custom_dialogue.dart';
import 'package:time_verse/core/components/initial_name_widget.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/home/controller/home_controller.dart';
import 'package:time_verse/features/settings/profile/controller/profile_controller.dart';


class HomeView extends StatelessWidget {
  final GlobalKey _shareKey = GlobalKey();

  HomeView({super.key});

  void _showFeedbackDialog(
  BuildContext context,
  bool isDarkMode,
  HomeController homeController,
) {
  homeController.clearFeedback();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer<HomeController>(
        builder: (context, controller, child) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              width: 340.w,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF051123) : const Color(0xFFFFF3D9),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Write your Feedback',
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : const Color(0xFF4A4A4A),
                    ),
                  ),
                  SizedBox(height: 20.h),
                    // Fixed Rating Row: Star outline becomes filled star
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        int ratingValue = index + 1;
                        bool isSelected = ratingValue <= controller.selectedRating;

                        return GestureDetector(
                          onTap: () => controller.updateRating(ratingValue),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Icon(
                              // If selected, show solid star; otherwise, show the star outline
                              isSelected ? Icons.star : Icons.star_border,
                              color: const Color(0xFFFFB800),
                              size: 32.sp,
                            ),
                          ),
                        );
                      }),
                    ),
                  SizedBox(height: 24.h),
                  Text(
                    'Your Feedback:',
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : const Color(0xFF4A4A4A),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: controller.feedbackController,
                    maxLines: 4,
                    style: GoogleFonts.outfit(color: isDarkMode ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDarkMode ? const Color(0xFF051123) : Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: const Color(0xFFFFB800).withOpacity(isDarkMode ? 0.5 : 1.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: Color(0xFFFFB800), width: 1.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.submitFeedback();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? const Color(0xFFC69C3D) : const Color(0xFFF39C12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        elevation: 0,
                      ),
                      child: Text(
                        isDarkMode ? 'Submit' : 'Submit Review',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final homeController = context.read<HomeController>();
    final profileController = context.read<ProfileController>();

    if (!homeController.isInitialized) {
    // 🛠️ FIX 1: Extract the route string synchronously BEFORE entering the async callback
    final currentRouteUri = GoRouterState.of(context).uri.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      homeController.initOnce(profileController);
      homeController.fetchAIMooodReflection();
      homeController.updateIndexFromRoute(currentRouteUri);
    });
  }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Header with logo, theme toggle and profile
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomUserInitialsAvatar(
                  userFirstName:UserSession().formattedUsername, 
                  //isDarkMode: isDarkMode,
                  size: 56.w,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        themeProvider.toggleTheme();
                      },
                      icon: SvgPicture.asset(
                        isDarkMode ? 'assets/icons/theme_dark.svg' : 'assets/icons/light_theme.svg',
                        width: 37.w,
                        height: 37.h,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        context.push('/profile');
                        },
                        child: SizedBox(
                          width: 40.w,
                          height: 40.w, 
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDarkMode ? AppColors.text_color: AppColors.heading_color,
                                width: 2,
                              ),
                            ),
                            child: 
                            ClipOval(
                              child: Selector<ProfileController, String?>(
                                selector: (_, controller) => controller.currentUser?.profilePicture,
                                builder: (_, profilePicture, __) {
                                  final imageProvider = (profilePicture != null && profilePicture.isNotEmpty)
                                    ? NetworkImage(profilePicture) as ImageProvider<Object>
                                    : const AssetImage('assets/images/profile_img.png') as ImageProvider<Object>;
                                  return Image(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30.h),            
            // Welcome Section with SVG Background
            Text(
              'Welcome',
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.w700,
                fontSize: 34.sp,
                color: isDarkMode? AppColors.fourth_color:Color(0xFF403D3B),
              ),
            ),
            //SizedBox(height: 10.h),            
            Consumer<ProfileController>(
              builder: (context, controller, _) {
                final username = controller.currentUser?.name ??
                UserSession().formattedUsername;
                  return Text(
                    username,
                    style: GoogleFonts.playfairDisplay(
                      fontWeight: FontWeight.w700,
                      fontSize: 34.sp,
                      color:  AppColors.fourth_color,
                      ),
                    );
                  },
                ),
              //SizedBox(height: 10.h),
            Text(
              'Have a mindful and blessed day',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.normal,
                fontSize: 14.sp,
                color: isDarkMode?Colors.white: Color(0xFF414141),
              ),
            ),
            SizedBox(height: 30.h),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 1.h,
                        width: double.infinity,
                        color: isDarkMode ? const Color(0xFF3B3B3B): const Color(0xFFF1A80A).withOpacity(0.6),
                      ),
                      // The floating Date Pill Header
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                          decoration: BoxDecoration(
                            color: isDarkMode ? const Color(0xFF060B13): Colors.white,
                            borderRadius: BorderRadius.circular(30.r),
                            // ✅ FIX: Main border frame line follows matching theme rules
                            border: Border.all(
                              color: isDarkMode ? const Color(0xFF3B3B3B): const Color(0xFFF1A80A).withOpacity(0.7),
                              width: 1,
                            ),
                            // Ambient glow shadow effect
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF1A80A).withOpacity(isDarkMode ? 0.05 : 0.08),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/calender_1.svg',
                                width: 16.w,
                                height: 16.h,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                DateFormat('EEEE, MMMM d').format(DateTime.now()),
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                  color: isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  // 2. Capsule Calendar Row Selection Grid
                  SizedBox(
                    height: 80.h,
                    child: Consumer<HomeController>(
                      builder: (context, controller, _) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 7,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          itemBuilder: (context, index) {
                            final now = DateTime.now();
                            final date = now.add(Duration(days: index - 3));
                            final isSelected =
                            date.day == controller.selectedDate.day &&
                            date.month == controller.selectedDate.month &&
                            date.year == controller.selectedDate.year;
                            return GestureDetector(
                              onTap: () {
                                controller.selectDate(date, profileController);
                              },
                              child: Container(
                                width: 54.w,
                                margin: EdgeInsets.symmetric(horizontal: 6.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                  ? const Color(0xFFF1A80A): (isDarkMode ? const Color(0xFF070F1A): Colors.white),
                                  borderRadius: BorderRadius.circular(24.r),
                                  border: Border.all(
                                    color: !isSelected ? (isDarkMode ? Colors.white: Colors.grey.shade300) : Colors.transparent,
                                    width: 0.2.sp,
                                  ),
                                  boxShadow: [
                                    if (!isSelected) ...[
                                      BoxShadow(
                                        color: isDarkMode ? Colors.white.withOpacity(0.3): Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                      ),
                                    ] else ...[
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _getDayName(date.weekday),
                                      style: GoogleFonts.outfit(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: isSelected ? const Color(0xFF060B13): (isDarkMode? const Color(0xFF7A8B9E): Colors.grey.shade600), // Dynamic unselected day color text
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      date.day.toString(),
                                      style: GoogleFonts.outfit(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? const Color(0xFF060B13): (isDarkMode? Colors.white: Colors.black), // Dynamic unselected date number text
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
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Container(
                width: 360.w,
                height: 421.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFC5A880).withOpacity(0.25),
                    width: 1,
                  ),
                  // 🖼️ YOUR BACKGROUND IMAGE PLACEMENT:
                  image: DecorationImage(
                    image: AssetImage(
                      isDarkMode ?'assets/images/container_bgimg.png':'assets/images/container_bgimg_light.png',
                    ), // Replace with your asset path
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    // 1. Top Bar: Category Chip & Moon Icon
    Padding(
  padding: EdgeInsets.only(
    left: 16.w,
    right: 16.w,
    top: 16.h,
  ),
  child: Consumer<HomeController>(
    builder: (context, homeController, child) {
      // 🛠️ FIX 1: Read purely from the reliable primitive index property to avoid layout conflicts
      final currentIdx = homeController.currentQuoteIndex;
          
      final currentQuote = homeController.inspirationalQuotes.isNotEmpty
          ? homeController.inspirationalQuotes[currentIdx % homeController.inspirationalQuotes.length]
          : null;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black.withOpacity(0.3) : const Color(0xFFFFF7E5),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(0xFFC5A880).withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wb_sunny_rounded,
                  color: const Color(0xFFFFA500),
                  size: 14.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  // 🛠️ FIX 2: Safely reads the database category string ('category_name') mapped from the API
                  currentQuote?.name != null && currentQuote!.name!.isNotEmpty 
                      ? currentQuote.name! 
                      : 'Motivation',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFFFA500),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  ),
),
SizedBox(height: 10.h),
SvgPicture.asset(
  'assets/icons/quote_mark.svg',
  width: 19.w,
  height: 20.h,
),
// 2. Carousel System Viewport
Expanded(
  child: RepaintBoundary(
    key: _shareKey, 
    child: GestureDetector(
      onPanStart: (_) => homeController.stopAutoSlide(),
      onPanEnd: (_) => homeController.startAutoSlide(),
      onTapDown: (_) => homeController.stopAutoSlide(),
      onTapUp: (_) => homeController.startAutoSlide(),
      child: Container(
        color: isDarkMode ? const Color(0xFF051123).withOpacity(0.2) : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white, height: 1.4),
          child: Consumer<HomeController>(
            builder: (context, controller, child) {
              // 🛠️ FIX: If the API hasn't finished loading yet or quotes are empty,
              // render a safe centered loading spinner. This prevents the PageView from collapsing.
              if (controller.inspirationalQuotes.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFFA500),
                  ),
                );
              }

              return PageView.builder(
                // 🛠️ Forces a safe layout layout re-generation if data changes lengths dynamically
                key: ValueKey(controller.inspirationalQuotes.length), 
                controller: controller.pageController,
                itemCount: controller.inspirationalQuotes.length,
                onPageChanged: (index) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      controller.updateQuoteIndex(index);
                    }
                  });
                },
                itemBuilder: (context, index) {
                  // Protect index bounds checking
                  if (index >= controller.inspirationalQuotes.length) {
                    return const SizedBox.shrink();
                  }
                  final quote = controller.inspirationalQuotes[index];
                  
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          quote.quote,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.sp,
                            color: isDarkMode ? Colors.white : Colors.black,
                            height: 1.3,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 30.w, height: 1, color: const Color(0xFFFFA500).withOpacity(0.5)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Icon(Icons.star, color: const Color(0xFFFFA500), size: 12.sp),
                          ),
                          Container(width: 30.w, height: 1, color: const Color(0xFFFFA500).withOpacity(0.5)),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        quote.reference,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: isDarkMode ? Colors.white60 : Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    ),
  ),
),
                    // 3. Bottom Action Utility Navigation Bar
                    Consumer<HomeController>(
                      builder: (context, homeController, _) {
                        return Container(
                          decoration: BoxDecoration(
                            color: isDarkMode ?Colors.black.withOpacity(0.35):Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12.r),
                              bottomRight: Radius.circular(12.r),
                            ),
                            border: Border(
                              top: BorderSide(
                                color: Colors.white.withOpacity(0.08),
                                width: 1,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          child: Row(
                            children: [
                              // Option A: Save to Favorites
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (homeController.inspirationalQuotes.isNotEmpty) {
                                      final currentQuote = homeController.inspirationalQuotes[homeController.currentQuoteIndex];
                                      debugPrint('Saving quote with ID: ${currentQuote.id}',);
                                      final success = await homeController.saveQuoteToFavorite(eventId: currentQuote.id ?? 0,);
                                      if (success) {
                                        await showMessageDialog(
                                          context,
                                          "Quote saved successfully!",
                                          title: "Success",
                                          icon: Icons.check_circle_outline,
                                          iconColor: Colors.green,
                                        );
                                      }
                                    }
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.favorite_border_rounded,
                                        color: isDarkMode?Colors.white: AppColors.fourth_color,
                                        size: 22.sp,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Favorite',
                                        style: GoogleFonts.outfit(
                                          color: isDarkMode?Colors.white: AppColors.fourth_color,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 24.h,
                                width: 1,
                                color: Colors.white.withOpacity(0.12),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final success = await homeController.saveQuoteImageToGallery();
                                    if (success) {
                                      await showMessageDialog(
                                        context,
                                        "Quote saved to gallery successfully!",
                                        title: "Success",
                                        icon: Icons.check_circle_outline,
                                        iconColor: Colors.green,
                                      );
                                    } else {
                                      await showMessageDialog(
                                        context,
                                        "Failed to save image.",
                                        title: "Error",
                                        icon: Icons.error_outline,
                                        iconColor: Colors.red,
                                      );
                                    }
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.bookmark_border_rounded,
                                        color: isDarkMode?Colors.white: AppColors.fourth_color,
                                        size: 22.sp,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Save',
                                        style: GoogleFonts.outfit(
                                          color: isDarkMode?Colors.white: AppColors.fourth_color,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 24.h,
                                width: 1,
                                color: Colors.white.withOpacity(0.12),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => homeController.shareQuoteAsImage(context),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.share_outlined,
                                        color: isDarkMode?Colors.white: AppColors.fourth_color,
                                        size: 22.sp,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Share',
                                        style: GoogleFonts.outfit(
                                          color: isDarkMode?Colors.white: AppColors.fourth_color,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              // Today's Schedule section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s Schedule',
                    style: GoogleFonts.playfairDisplay(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      color: isDarkMode? AppColors.l_schedule_clr3: AppColors.heading_color,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Color(0xFFF6AD14).withOpacity(0.65):  Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.push('/all_events');
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h,),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'See all',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFFFFA500,), 
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.arrow_right_alt_rounded,
                              color: const Color(0xFFFFA500),
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Schedule events list
              Consumer<HomeController>(
                builder: (context, controller, _) {
                  final events = controller.todaysEvents;
                  if (events.isEmpty) {
                    return Text(
                      'No review yet',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: isDarkMode? AppColors.fourth_color: AppColors.heading_color,
                      ),
                    );
                  }
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isDarkMode
                      ? const Color(0xFF051123): Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFFC5A880).withOpacity(0.35),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: List.generate(events.length, (index) {
                            final event = events[index];
                            final isLastItem = index == events.length - 1;
                            String calculatedPeriod = "Morning";
                            try {
                              final startHourStr = (event.startTime).split(':').first.trim();
                              final int hourValue = int.parse(startHourStr);
                              if (hourValue >= 12) {
                                calculatedPeriod = "Afternoon";
                              }
                            } catch (_) {
                              calculatedPeriod = "Morning";
                            }
                            bool showHeaderLabel = false;
                            if (index == 0) {
                              showHeaderLabel = true;
                            } else {
                              final priorEvent = events[index - 1];
                              String priorPeriod = "Morning";
                              try {
                                final priorHourStr = (priorEvent.startTime).split(':').first.trim();
                                if (int.parse(priorHourStr) >= 12)
                                  priorPeriod = "Afternoon";
                              } catch (_) {}
                              if (calculatedPeriod != priorPeriod) {
                                showHeaderLabel = true;
                              }
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (showHeaderLabel) ...[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 16.h,
                                      top: index > 0 ? 16.h : 0,
                                    ),
                                    child: Text(
                                      calculatedPeriod,
                                      style: GoogleFonts.playfairDisplay(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                        color: const Color(0xFFFFA500),
                                      ),
                                    ),
                                  ),
                                ],
                                _buildScheduleEvent(
                                  context,
                                  event.id,
                                  event.title,
                                  '${event.startTime} - ${event.endTime}',
                                  event.category_name ?? '',
                                  event.location,
                                  event.description,
                                  Colors.grey,
                                  isDarkMode,
                                  lightModeBackgroundColor:AppColors.l_schedule_clr1,
                                  isLastItem: isLastItem,
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 30.h),
              Consumer<HomeController>(
                builder: (context, homeController, _) {
                  final aiReflectionText =homeController.currentReflection?.aiReflection.isNotEmpty == true
                    ? homeController.currentReflection!.aiReflection
                    : 'Today feels centered around connection, gratitude and emotionally meaningful movement.';
                  return Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6AD14).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFFFFB800).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Reflections',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            color: AppColors.fourth_color,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          aiReflectionText, // 🛠️ Dynamic reflection text rendered here
                          textAlign: TextAlign.start,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: isDarkMode
                            ? AppColors.l_schedule_clr3
                            : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Leave us a feedback',
                    style: GoogleFonts.playfairDisplay(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      color: isDarkMode?AppColors.l_schedule_clr3: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showFeedbackDialog(
                      context,
                      isDarkMode,
                      homeController,
                    ),
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: isDarkMode ?Colors.white.withOpacity(0.1): AppColors.button_color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.fourth_color.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20.sp),
                    ),
                  ),
                ],
              ),
              //SizedBox(height: 16.h),
              // Consumer<HomeController>(
              //   builder: (context, controller, _) {
              //     if (controller.reviews.isEmpty) {
              //       return Center(
              //         child: Text(
              //           'No reviews available.',
              //           style: GoogleFonts.outfit(
              //             color: isDarkMode ? Colors.white : Colors.black,
              //             fontSize: 14.sp,
              //           ),
              //         ),
              //       );
              //     }
              //     return Column(
              //       children: List.generate(controller.reviews.length, (index) {
              //         final review = controller.reviews[index];
              //         return Container(
              //           width: double.infinity,
              //           margin: EdgeInsets.only(bottom: 12.h),
              //           padding: EdgeInsets.all(16.w),
              //           decoration: BoxDecoration(
              //             color: isDarkMode
              //             ? AppColors.containers_bgd
              //             : Colors.white,
              //             borderRadius: BorderRadius.circular(12.r),
              //             border: Border.all(
              //               color: isDarkMode
              //               ? const Color(0xFFFFB800).withOpacity(0.3)
              //               : Colors.grey.withOpacity(0.2),
              //             ),
              //           ),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Row(
              //                 children: [
              //                   Container(
              //                     width: 40.w,
              //                     height: 40.h,
              //                     decoration: BoxDecoration(
              //                       color: Colors.grey.withOpacity(0.3),
              //                       borderRadius: BorderRadius.circular(20.r),
              //                     ),
              //                     child: Icon(
              //                       Icons.person,
              //                       color: Colors.grey,
              //                       size: 20.sp,
              //                     ),
              //                   ),
              //                   SizedBox(width: 12.w),
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         review.userName,
              //                         style: GoogleFonts.outfit(
              //                           fontWeight: FontWeight.w600,
              //                           fontSize: 14.sp,
              //                           color: isDarkMode
              //                           ? Colors.white
              //                           : Colors.black,
              //                         ),
              //                       ),
              //                       Row(
              //                         children: List.generate(
              //                           review.rating,
              //                           (index) => Icon(
              //                             Icons.star,
              //                             color: const Color(0xFFFFB800),
              //                             size: 12.sp,
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ],
              //               ),
              //               SizedBox(height: 12.h),
              //               Text(
              //                 '"${review.comments}"',
              //                 style: GoogleFonts.outfit(
              //                   fontWeight: FontWeight.w400,
              //                   fontSize: 14.sp,
              //                   color: isDarkMode
              //                   ? Colors.white.withOpacity(0.8)
              //                   : Colors.black.withOpacity(0.8),
              //                   height: 1.4,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         );
              //       }),
              //     );
              //   },
              // ),
              SizedBox(height: 30.h),
              // Unlock More Blessings section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: isDarkMode
                  ? const Color(0xFF051123): const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDarkMode
                    ? const Color(0xFFC5A880).withOpacity(0.35)
                    : Colors.transparent,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Unlock More Blessings',
                      style: GoogleFonts.playfairDisplay(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                        color: const Color(0xFFFFA500),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SvgPicture.asset(
                      'assets/icons/premium_icon.svg',
                      width: 72.w,
                      height: 72.h,
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {
                        context.push('/subscription');
                      },
                      child: Container(
                        width: 160.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5B301),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Center(
                          child: Text(
                            'Go Premium',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 120.h,)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<HomeController>(
        builder: (context, controller, _) => CustomBottomNavBar(),
      ),
    );
  }

  // Widget _buildScheduleEvent(
  //   BuildContext context,
  //   int id,
  //   String title,
  //   String time,
  //   Color indicatorColor,
  //   bool isDarkMode, {
  //   Color? lightModeBackgroundColor,
  // }) {
  //   return GestureDetector(
  //     onTap: (){
  //       context.push('/event_details', extra: id);
  //     },
  //     child:Container(
  //     width: double.infinity,
  //     padding: EdgeInsets.all(16.w),
  //     decoration: BoxDecoration(
  //       color: isDarkMode
  //         ? AppColors.containers_bgd
  //         : (lightModeBackgroundColor ?? Colors.white),
  //       borderRadius: BorderRadius.circular(12.r),
  //       border: Border.all(
  //         // ignore: deprecated_member_use
  //         color: isDarkMode ? const Color(0xFFFFB800).withOpacity(0.3) : Colors.grey.withOpacity(0.2),
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 8.w,
  //           height: 8.h,
  //           decoration: BoxDecoration(
  //             color: indicatorColor,
  //             borderRadius: BorderRadius.circular(4.r),
  //           ),
  //         ),
  //         SizedBox(width: 16.w),
  //         Flexible(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 title,
  //                 style: GoogleFonts.outfit(
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 16.sp,
  //                   color: isDarkMode ? Colors.white : Colors.black,
  //                 ),
  //               ),
  //               SizedBox(height: 4.h),
  //               Text(
  //                 time,
  //                 style: GoogleFonts.outfit(
  //                   fontWeight: FontWeight.w400,
  //                   fontSize: 14.sp,
  //                   // ignore: deprecated_member_use
  //                   color: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     )
  //   );
  // }

  Widget _buildScheduleEvent(
    BuildContext context,
    int id,
    String title,
    String time,
    String category,
    String location,
    String subtitle,
    Color indicatorColor,
    bool isDarkMode, {
    Color? lightModeBackgroundColor,
    bool isLastItem = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left custom tracker track spine framework matching design target visuals
          SizedBox(
            width: 24.w,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Continuous vertical alignment connecting background path pillar line segment
                if (!isLastItem)
                  Positioned(
                    top: 6.h,
                    bottom: 0,
                    child: Container(
                      width: 1.5.w,
                      // ignore: deprecated_member_use
                      color: const Color(0xFFC5A880).withOpacity(0.35),
                    ),
                  ),
                // Horizontal cross-connecting node offset row segment
                Positioned(
                  top: 6.h,
                  left: 6.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Outer structural glowing circular core badge node accent
                      Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFA500),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFA500).withOpacity(0.4),
                              blurRadius: 6.r,
                              spreadRadius: 1.r,
                            ),
                          ],
                        ),
                      ),
                      // Linking line projecting outward into matching edge of target cell block frame container
                      Container(
                        width: 6.w,
                        height: 1.5.h,
                        color: const Color(0xFFC5A880).withOpacity(0.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Right Content Dynamic Textured Panel Card Container Frame
          Expanded(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    context.push('/event_details', extra: id);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isDarkMode
                      ? const Color(0xFF09121F)
                      : Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFFC5A880).withOpacity(0.2),
                      ),
                      image:DecorationImage(
                        image: AssetImage(
                          isDarkMode ?'assets/images/container_bgm.jpg': 'assets/images/container_bgm_light.png'
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.15),
                                ),
                              ),
                              child: Text(
                                category.isEmpty ? 'General' : category,
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF7A8B9E),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              time,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                                color: const Color(0xFFFFA500),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          title,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        if (location.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Text(
                                '📍',
                                style: TextStyle(
                                  fontSize: 14.sp, 
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (subtitle.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(
                                Icons.description_outlined,
                                color: const Color(0xFF7A8B9E),
                                size: 14.sp,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    color: isDarkMode
                                        ? Colors.white60
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: isLastItem ? 0 : 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
