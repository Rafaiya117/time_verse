import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_bottomnav.dart';
import 'package:time_verse/core/components/custom_dialogue.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/home/controller/home_controller.dart';
import 'package:time_verse/features/settings/profile/user_service/user_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  void _showFeedbackDialog(BuildContext context, bool isDarkMode, HomeController homeController) {
    homeController.clearFeedback();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<HomeController>(
          builder: (context, controller, child) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 320.w,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF051123) : const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDarkMode ? const Color(0xFFFFB800).withOpacity(0.3) : Colors.grey.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Write your Feedback',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    
                    // Star Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            controller.updateRating(index + 1);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Icon(
                              controller.selectedRating > index ? Icons.star : Icons.star_border,
                              color: const Color(0xFFFFB800),
                              size: 32.sp,
                            ),
                          ),
                        );
                      }),
                    ),                    
                    SizedBox(height: 20.h),                    
                    Text(
                      'Your Feedback:',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),                    
                    SizedBox(height: 12.h),                    
                    // Feedback Text Field
                    Container(
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isDarkMode ? const Color(0xFFFFB800).withOpacity(0.3) : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: TextField(
                        controller: controller.feedbackController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Share your thoughts...',
                          hintStyle: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12.w),
                        ),
                      ),
                    ),                    
                    SizedBox(height: 24.h),                    
                    // Submit Button
                    GestureDetector(
                      onTap: () async {
                        //controller.submitFeedback();
                        await controller.postReviewToApi();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Thank you for your feedback!',
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: const Color(0xFFFFB800),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB800),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            controller.selectedRating > 0 ? 'Submit Review' : 'Submit',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
                            ),
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
    final homeController = Provider.of<HomeController>(context, listen: false);
    final location = GoRouterState.of(context).uri.toString();
    homeController.updateIndexFromRoute(location);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final logoPath = isDarkMode ? 'assets/icons/logo_dark.svg' : 'assets/icons/logo_light.svg';
    // Start auto-slide when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      homeController.startAutoSlide();
      homeController.fetchSavedQuotes();
      //homeController.fetchQuotesFromApi();
      await Future.delayed(const Duration(milliseconds: 200));
      homeController.fetchReviewsFromApi();
    });
    
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
                  SvgPicture.asset(
                    logoPath,
                    width: logoPath.contains('logo_light') ? 58.w : 28.w,
                    height: logoPath.contains('logo_light') ? 58.h : 28.h,
                    //fit: BoxFit.contain,
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
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDarkMode ? AppColors.text_color : AppColors.heading_color,
                            width: 2,
                          ),
                        ),
                        child: 
                        // ClipOval(
                        //   child: Image.asset(
                        //     'assets/images/profile_img.png',
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        ClipOval(
                          child: Builder(
                            builder: (_) {
                              final userService = UserService();
                              final user = userService.currentUser;
                              debugPrint('!-----${user?.profilePicture}');
                              final imageProvider = user?.profilePicture != null
                                ? NetworkImage(
                                  'http://10.10.13.74:5000/${user!.profilePicture}',
                                )
                              : const AssetImage(
                                'assets/images/profile_img.png',
                              );
                              return Image(
                                image: imageProvider as ImageProvider,
                                fit: BoxFit.cover,
                              );
                            },
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
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                fontSize: 34.sp,
                color: isDarkMode? AppColors.fourth_color:Color(0xFF403D3B),
              ),
            ),
            //SizedBox(height: 10.h),            
            Text(
              'Mellisa\n Peters',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.normal,
                fontSize: 34.sp,
                color: isDarkMode? AppColors.fourth_color:Color(0xFF403D3B),
              ),
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
            // Calendar Section
            Center(
              child: Text(
                DateFormat('EEEE, MMMM d').format(DateTime.now()),
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: isDarkMode ? AppColors.text_color : AppColors.heading_color,
                ),
              ),
            ),
            SizedBox(height: 15.h),
            
            Container(
              height: 80.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  final now = DateTime.now();
                  final date = now.add(Duration(days: index - 3)); 
                  final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
                  
                  return Container(
                    width: 60.w,
                    margin: EdgeInsets.only(right: 12.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getDayName(date.weekday),
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: isToday 
                              ? (isDarkMode ? AppColors.fourth_color : AppColors.heading_color)
                              : (isDarkMode ? AppColors.text_color : AppColors.heading_color),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          date.day.toString(),
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: isToday 
                              ? (isDarkMode ? AppColors.fourth_color : AppColors.heading_color)
                              : (isDarkMode ? AppColors.text_color : AppColors.heading_color),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30.h),            
            // Daily Inspiration Section
            Text(
              'Daily Inspiration',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                color: isDarkMode ? AppColors.text_color : AppColors.heading_color,
              ),
            ),
            SizedBox(height: 20.h),            
            Container(
              width: 360.w,
              height: 421.h,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF051123) : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.third_color.withOpacity(0.3),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:24.w, vertical: 100.h),
                child: Column(
                  children: [
                    // Quote icon
                    // Container(
                    //   width: 48.w,
                    //   height: 48.h,
                    //   decoration: BoxDecoration(
                    //     color: isDarkMode ? const Color(0xFF8B6914) : const Color(0xFFFFF4E6),
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: SvgPicture.asset(
                    //     'assets/icons/qoute_icon.svg',
                    //     // ignore: deprecated_member_use
                    //     color: isDarkMode ? const Color(0xFFFFD700) : const Color(0xFFFFA500),
                    //     width: 24.w,
                    //     height: 24.h,
                    //   ),
                    // ),
                    // SizedBox(height: 24.h),
                    
                    // // Title
                    // Text(
                    //   'Your Daily Inspiration',
                    //   style: GoogleFonts.outfit(
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 20.sp,
                    //     color: isDarkMode ? Colors.white : Colors.black,
                    //   ),
                    // ),
                    // SizedBox(height: 8.h),
                    
                    // // Subtitle
                    // Text(
                    //   'Generated from your calendar',
                    //   style: GoogleFonts.outfit(
                    //     fontWeight: FontWeight.w400,
                    //     fontSize: 14.sp,
                    //     color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    //   ),
                    // ),
                    // SizedBox(height: 32.h),
                    
                    // Quote PageView
                    // SizedBox(
                    //   height: 120.h,
                    //     child: GestureDetector(
                    //       onPanStart: (_) => homeController.stopAutoSlide(),
                    //       onPanEnd: (_) => homeController.startAutoSlide(),
                    //       onTapDown: (_) => homeController.stopAutoSlide(),
                    //       onTapUp: (_) => homeController.startAutoSlide(),
                    //       child: PageView.builder(
                    //         controller: homeController.pageController,
                    //         itemCount:homeController.inspirationalQuotes.length,
                    //         onPageChanged: (index) {
                    //           homeController.updateQuoteIndex(index);
                    //         },
                    //         itemBuilder: (context, index) {
                    //           final quote = homeController.inspirationalQuotes[index];
                    //           return Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Flexible(
                    //                 child: Text(
                    //                   quote.quote,
                    //                   textAlign: TextAlign.center,
                    //                   style: GoogleFonts.outfit(
                    //                     fontWeight: FontWeight.w500,
                    //                     fontSize: 16.sp,
                    //                     color: isDarkMode
                    //                       ? Colors.white
                    //                       : Colors.black,
                    //                     height: 1.4,
                    //                   ),
                    //                 ),
                    //               ),
                    //               SizedBox(height: 16.h),
                    //               Text(
                    //                 quote.reference,
                    //                 style: GoogleFonts.outfit(
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 14.sp,
                    //                   color: isDarkMode
                    //                     ? const Color(0xFFFFD700)
                    //                     : const Color(0xFFFF8C00),
                    //                   fontStyle: FontStyle.italic,
                    //                 ),
                    //               ),
                    //             ],
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    Consumer<HomeController>(
                      builder: (context, homeController, child) {
                        return Column(
                          children: [
                            SizedBox(
                                height: 120.h,
                                child: GestureDetector(
                                  onPanStart: (_) => homeController.stopAutoSlide(),
                                  onPanEnd: (_) => homeController.startAutoSlide(),
                                  onTapDown: (_) => homeController.stopAutoSlide(),
                                  onTapUp: (_) => homeController.startAutoSlide(),
                                  child: RepaintBoundary(
                                    key: homeController.quoteShareKey,
                                    child: PageView.builder(
                                      controller: homeController.pageController,
                                      itemCount: homeController.inspirationalQuotes.length,
                                      onPageChanged: (index) {
                                        homeController.updateQuoteIndex(index);
                                      },
                                      itemBuilder: (context, index) {
                                        final quote = homeController.inspirationalQuotes[index];
                                        return Column(
                                          mainAxisAlignment:MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                quote.quote,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.sp,
                                                  color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 16.h),
                                            Text(
                                              quote.reference,
                                              style: GoogleFonts.outfit(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.sp,
                                                color: isDarkMode
                                                  ? const Color(0xFFFFD700)
                                                  : const Color(0xFFFF8C00),
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
                              SizedBox(height: 5.h),
                              // DOT INDICATORS
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  homeController.inspirationalQuotes.length > 5 ? 5
                                  : homeController.inspirationalQuotes.length,
                                  (i) {
                                    final index = i + (homeController.currentQuoteIndex ~/5) *5;
                                    final actualIndex = index % homeController.inspirationalQuotes.length;
                                    return GestureDetector(
                                      onTap: () => homeController.goToQuote(actualIndex),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 4.w,),
                                        width:homeController.currentQuoteIndex == actualIndex
                                          ? 12.w: 8.w,
                                        height: homeController.currentQuoteIndex == actualIndex
                                          ? 12.h: 8.h,
                                        decoration: BoxDecoration(
                                          color:homeController.currentQuoteIndex == actualIndex
                                            ? (isDarkMode ? const Color(0xFFFFD700) : const Color(0xFFFF8C00))
                                            : (isDarkMode ? Colors.grey[600]: Colors.grey[400]),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 20.h),                    
                    // Action buttons
                    Row(
                      children: [
                        // Save button
                        Flexible(
                          child: Container(
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF0F4FF),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isDarkMode ? const Color(0xFFFFB800) : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                final currentQuote = homeController.inspirationalQuotes[homeController.currentQuoteIndex];
                                debugPrint('Saving quote with ID: ${currentQuote.id}',);
                                final success = await homeController.saveQuoteToFavorite(eventId: currentQuote.id ?? 0,);
                                  if (success) {
                                    // Replace SnackBar with dialog
                                    await showMessageDialog(
                                      context,
                                      "Quote saved successfully!",
                                      title: "Success",
                                      icon: Icons.check_circle_outline,
                                      iconColor: Colors.green,
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/download.svg',
                                      color: isDarkMode
                                        ? Colors.white
                                        : const Color(0xFF4A90E2),
                                      width: 20.sp,
                                      height: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Save',
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                        color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF4A90E2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),                       
                        // Share button
                        Flexible(
                          child: GestureDetector(
                            onTap: (){
                              homeController.shareQuoteAsImage(context);
                            },
                            child:Container(
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFA500),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  isDarkMode?'assets/icons/share_filled.svg':'assets/icons/share.svg',
                                  // ignore: deprecated_member_use
                                  color: isDarkMode ? AppColors.text_color :AppColors.heading_color,
                                  width: 20.sp,
                                  height: 20.sp
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Share',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    color: isDarkMode ? AppColors.text_color: AppColors.heading_color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.h),
            // Today's Schedule section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Schedule',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: isDarkMode ? AppColors.fourth_color : AppColors.heading_color,
                  ),
                ),
                Text(
                  '5 events',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: isDarkMode ? AppColors.fourth_color : AppColors.heading_color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),            
            // Schedule events list
            Column(
              children: [
                _buildScheduleEvent(
                  context,
                  'Team Standup',
                  '9:00 AM - 9:30 AM',
                  const Color(0xFFFFD700),
                  isDarkMode,
                  lightModeBackgroundColor: AppColors.l_schedule_clr1,
                ),
                SizedBox(height: 12.h),
                _buildScheduleEvent(
                  context,
                  'Client Presentation',
                  '11:00 AM - 12:00 PM',
                  Colors.grey,
                  isDarkMode,
                  lightModeBackgroundColor: AppColors.l_schedule_clr2,
                ),
                SizedBox(height: 12.h),
                _buildScheduleEvent(
                  context,
                  'Lunch Break',
                  '12:30 PM - 1:30 PM',
                  const Color(0xFFFFB800),
                  isDarkMode,
                  lightModeBackgroundColor: AppColors.l_schedule_clr3,
                ),
              ],
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
            
            // What Our Users Are Saying section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'What Our Users Are Saying?',
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
            // User testimonial
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
                          color: isDarkMode
                            ? AppColors.containers_bgd
                            : AppColors.background_color,
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
                                        color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
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

  Widget _buildScheduleEvent(
    BuildContext context,
    String title,
    String time,
    Color indicatorColor,
    bool isDarkMode, {
    Color? lightModeBackgroundColor,
  }) {
    return GestureDetector(
      onTap: (){
        context.push('/event_details');
      },
      child:Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode 
          ? AppColors.containers_bgd 
          : (lightModeBackgroundColor ?? Colors.white),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          // ignore: deprecated_member_use
          color: isDarkMode ? const Color(0xFFFFB800).withOpacity(0.3) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(width: 16.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  time,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    // ignore: deprecated_member_use
                    color: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
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