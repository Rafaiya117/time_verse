import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/core/components/custom_bottomnav.dart';
import 'package:time_verse/core/components/custom_dialogue.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/home/controller/home_controller.dart';
import 'package:time_verse/features/settings/profile/controller/profile_controller.dart';


class HomeView extends StatelessWidget {
  const HomeView({super.key});

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

    /// ✅ Run once when widget appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.initOnce(profileController);
    });

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final String logoPath = isDarkMode
      ? 'assets/images/logo.png'
      : 'assets/images/logo_light.png';
    return Scaffold(
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
                  Image.asset(
                    logoPath,
                    width:68.w ,
                    height:54.h ,
                    fit: BoxFit.contain,
                  ),
                  Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        themeProvider.toggleTheme();
                      },
                      icon: SvgPicture.asset(
                        isDarkMode ? 'assets/icons/theme_dark.svg' : 'assets/icons/light_theme.svg',
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                        onTap: () {
                          context.push('/profile');
                        },
                        child: SizedBox(
                          width: 40.w,
                          height: 40.w, // ✅ FIX: use same scaling unit to prevent stretch
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDarkMode
                                  ? AppColors.text_color
                                  : AppColors.heading_color,
                                width: 2,
                              ),
                            ),
                            child: 
                            ClipOval(
                              child: Selector<ProfileController, String?>(
                                selector: (_, controller) => controller.currentUser?.profilePicture,
                                builder: (_, profilePicture, __) {
                                  debugPrint(
                                    '!----Profile image -----------$profilePicture',
                                  );

                                  final imageProvider = (profilePicture != null && profilePicture.isNotEmpty)
                                    ? NetworkImage(profilePicture) as ImageProvider<Object>
                                      : const AssetImage(
                                      'assets/images/profile_img.png',
                                    ) as ImageProvider<Object>;

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
                      color: isDarkMode
                        ? AppColors.fourth_color
                        : const Color(0xFF403D3B),
                      ),
                    );
                  },
                ),
            // Container(
            //   width: 384.w,
            //   height: 224.h,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(12.r),
            //   ),
            //   child: Stack(
            //     children: [
            //       //Background SVG
            //       SvgPicture.asset(
            //         isDarkMode 
            //           ? 'assets/images/WelcomeSection_d.svg'
            //           : 'assets/images/WelcomeSection_w.svg',
            //         width: 384.w,
            //         height: 224.h,
            //         fit: BoxFit.cover,
            //       ),                                    
            //     ],
            //   ),
            // ),
            SizedBox(height: 30.h),
              Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    // 1. Floating Header Container Stack with background reference line
    Stack(
      alignment: Alignment.center,
      children: [
        // The continuous accent line passing strictly behind the center card
        Container(
          height: 1.h,
          width: double.infinity,
          color: Colors.white.withOpacity(0.12),
        ),
        // The floating Date Pill Header
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF060B13),
              borderRadius: BorderRadius.circular(30.r),
              // Clean brand border frame outline
              border: Border.all(
                color: const Color(0xFFC5A880).withOpacity(0.2),
                width: 1,
              ),
              // Ambient glow shadow effect
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF1A80A).withOpacity(0.08),
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
                    color: Colors.white,
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
                final isSelected = date.day == controller.selectedDate.day && date.month == controller.selectedDate.month && date.year == controller.selectedDate.year;
                  return GestureDetector(
                  onTap: () {
                    controller.selectDate(date, profileController);
                  },
                  child: Container(
                    width: 54.w,
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF1A80A) : const Color(0xFF070F1A),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: !isSelected ? Colors.white : Colors.transparent,width: 0.2.sp,
                      ),
                      boxShadow: [
                        if (!isSelected) ...[
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                          // BoxShadow(
                          //   color: Colors.white.withOpacity(0.35),
                          //   blurRadius: 12,
                          //   spreadRadius: 2,
                          // ),
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
                            color: isSelected ? const Color(0xFF060B13): const Color(0xFF7A8B9E),
                          ),
                        ),
                        SizedBox(height: 6.h),
                          Text(
                            date.day.toString(),
                              style: GoogleFonts.outfit(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                ? const Color(0xFF060B13)
                                : Colors.white,
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
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/container_bgimg.png',
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Floating Category Tag Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
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
                                  'Motivation',
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
                      ),
                    ),

                    // Giant Decorative Quote Marks Symbol
                    SizedBox(height: 10.h),
                    SvgPicture.asset(
                      'assets/icons/quote_mark.svg',
                      width: 19.w,
                      height: 20.h,
                    ),
                    // Text(
                    //   '“',
                    //   style: GoogleFonts.playfairDisplay(
                    //     fontSize: 48.sp,
                    //     color: const Color(0xFFFFA500),
                    //     fontWeight: FontWeight.bold,
                    //     height: 0.6,
                    //   ),
                    // ),

                    // 2. Core Inspirational Quote Content Carousel (PageView)
                    Expanded(
                      child: Consumer<HomeController>(
                        builder: (context, homeController, child) {
                          return GestureDetector(
                            onPanStart: (_) => homeController.stopAutoSlide(),
                            onPanEnd: (_) => homeController.startAutoSlide(),
                            onTapDown: (_) => homeController.stopAutoSlide(),
                            onTapUp: (_) => homeController.startAutoSlide(),
                            child: RepaintBoundary(
                              key: homeController.quoteShareKey,
                              child: Container(
                                color: isDarkMode
                                    ? const Color(0xFF051123).withOpacity(0.2)
                                    : Colors.transparent,
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: DefaultTextStyle(
                                  style: const TextStyle(
                                    color: Colors.white,
                                    height: 1.4,
                                  ),
                                  child: PageView.builder(
                                    controller: homeController.pageController,
                                    itemCount: homeController
                                        .inspirationalQuotes
                                        .length,
                                    onPageChanged: (index) {
                                      homeController.updateQuoteIndex(index);
                                    },
                                    itemBuilder: (context, index) {
                                      final quote = homeController
                                          .inspirationalQuotes[index];
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              quote.quote,
                                              textAlign: TextAlign.center,
                                              style:
                                                  GoogleFonts.playfairDisplay(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22.sp,
                                                    color: Colors.white,
                                                    height: 1.3,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          // Diamond Flare Design Divider Line
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 30.w,
                                                height: 1,
                                                color: const Color(
                                                  0xFFFFA500,
                                                ).withOpacity(0.5),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                ),
                                                child: Icon(
                                                  Icons.star,
                                                  color: const Color(
                                                    0xFFFFA500,
                                                  ),
                                                  size: 12.sp,
                                                ),
                                              ),
                                              Container(
                                                width: 30.w,
                                                height: 1,
                                                color: const Color(
                                                  0xFFFFA500,
                                                ).withOpacity(0.5),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12.h),
                                          Text(
                                            quote.reference,
                                            style: GoogleFonts.outfit(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                              color: Colors.white60,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // 3. Bottom Action Utility Navigation Bar
                    Consumer<HomeController>(
                      builder: (context, homeController, _) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
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
                                      debugPrint(
                                        'Saving quote with ID: ${currentQuote.id}',
                                      );
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
                                        color: Colors.white,
                                        size: 22.sp,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Favorite',
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
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

                              // Option B: Download/Save to Local Storage Gallery
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
                                        color: Colors.white,
                                        size: 22.sp,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Save',
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
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
                                        color: Colors.white,
                                        size: 22.sp,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Share',
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
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
                      color: const Color(0xFFF6AD14).withOpacity(0.65),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.push('/add_event');
                      },
                      borderRadius: BorderRadius.circular(30.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'See all',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFFFFA500,), // Vibrant amber brand font tone
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
                        color: isDarkMode
                          ? AppColors.fourth_color
                          : AppColors.heading_color,
                        ),
                      );
                    }

                  return Column(
                    children: events.map((event) {
                      return Column(
                        children: [
                          _buildScheduleEvent(
                            context,
                            event.id,
                            event.title,
                            '${event.startTime} - ${event.endTime}',
                            event.category ?? "", // 👈 Pass your dynamic category string from the backend here
                            event.subtitle ?? "", // 👈 Pass your dynamic subtitle string from the backend here
                            Colors.grey,
                            isDarkMode,
                            lightModeBackgroundColor: AppColors.l_schedule_clr1,
                          ),
                          SizedBox(height: 12.h),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            SizedBox(height: 16.h),
            Center(
              child: TextButton(
                onPressed: (){
                  context.push('/all_events');
                }, 
                child: Text(
                  'View all events',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: const Color(0xFFFFB800),
                  ),
                ),
              )
            ),            
            SizedBox(height: 30.h),            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'What Other Users Are Saying?',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: const Color(0xFFFFB800),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showFeedbackDialog(context, isDarkMode, homeController),
                  child: Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB800),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.add,
                      color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),            
            Consumer<HomeController>(
              builder: (context, controller, _) {
                if (controller.reviews.isEmpty) {
                  return Center(
                    child: Text(
                      'No reviews available.',
                      style: GoogleFonts.outfit(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }
                return Column(
                  children: List.generate(controller.reviews.length, (index) {
                    final review = controller.reviews[index];
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: isDarkMode? AppColors.containers_bgd: AppColors.background_color,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isDarkMode
                              // ignore: deprecated_member_use
                              ? const Color(0xFFFFB800).withOpacity(0.3)
                              // ignore: deprecated_member_use
                              : Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    // ignore: deprecated_member_use
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 20.sp,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review.userEmail,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: isDarkMode? Colors.white: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(
                                        review.rating ?? 0,
                                        (index) => Icon(
                                          Icons.star,
                                          color: const Color(0xFFFFB800),
                                          size: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              '"${review.comments}"',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: isDarkMode
                                  // ignore: deprecated_member_use
                                  ? Colors.white.withOpacity(0.8)
                                  // ignore: deprecated_member_use
                                  : Colors.black.withOpacity(0.8),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                },
              ),
              SizedBox(height: 30.h),            
            // Unlock More Blessings section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF051123) : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  // ignore: deprecated_member_use
                  color: isDarkMode ? const Color(0xFFFFB800).withOpacity(0.3) : Colors.transparent,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Unlock More Blessings',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                      color: const Color(0xFFFFB800),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Icon(
                    Icons.star,
                    color: const Color(0xFFFFB800),
                    size: 32.sp,
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8860B),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: (){
                          context.push('/subscription');
                        },
                        child: Text(
                        'Go Premium',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
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
  String category,      // Dynamically fed from backend payload data
  String subtitle,      // Dynamically fed from backend payload data
  Color indicatorColor,
  bool isDarkMode, {
  Color? lightModeBackgroundColor,
}) {
  // 🕐 Dynamically evaluate if the event is in the Morning or Afternoon
  String periodLabel = "Morning";
  try {
    final lowercaseTime = time.toLowerCase();
    if (lowercaseTime.contains("pm") || lowercaseTime.contains("afternoon")) {
      periodLabel = "Afternoon";
    } else if (lowercaseTime.contains("am")) {
      periodLabel = "Morning";
    } else {
      final firstHourToken = time.split(':').first.trim();
      final hour = int.parse(firstHourToken);
      if (hour >= 12) periodLabel = "Afternoon";
    }
  } catch (_) {
    periodLabel = "Afternoon"; // Graceful fallback
  }

  return GestureDetector(
    onTap: () {
      context.push('/event_details', extra: id);
    },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? const Color(0xFF051123) 
            : (lightModeBackgroundColor ?? Colors.white),
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
          // 🌤️ Period Header Title Text Label (Morning / Afternoon)
          Text(
            periodLabel,
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: const Color(0xFFFFA500),
            ),
          ),
          SizedBox(height: 12.h),

          // 🖼️ INNER CONTAINER INNER CONTENT WRAPPER FRAME
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF09121F) : Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: const Color(0xFFC5A880).withOpacity(0.2),
              ),
              // 👇 PLACE YOUR INNER CONTAINER TEXTURED BACKGROUND ASSET RIGHT HERE 👇
              image: const DecorationImage(
                image: AssetImage('assets/images/your_inner_texture.png'), // Swap with your file asset path string
                fit: BoxFit.cover,
              ),
              // 👆 PLACE YOUR INNER CONTAINER TEXTURED BACKGROUND ASSET RIGHT HERE 👆
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meta Badge Category Line & Time Placement Strip Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dynamic Tag Label Category Chip Frame
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: Text(
                        category, 
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF7A8B9E),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Dynamic Time Stamp Tracking String
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

                // Core Main Dynamic Event Title Text Header
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 6.h),

                // Secondary Subtitle Segment Location Frame Row Block
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded, 
                      color: const Color(0xFFFF4D4D), // Reddish accent custom map point marker pin shade
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        subtitle, 
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: isDarkMode ? Colors.white70 : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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