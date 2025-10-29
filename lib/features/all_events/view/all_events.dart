import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/all_events/controller/all_events.dart';

class AllEvents extends StatelessWidget {
  const AllEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final location = GoRouterState.of(context).uri.toString();
    final controller = Provider.of<AllEventsController>(context, listen: false);
    controller.updateIndexFromRoute(location);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
            Container(
              width: 327.w,
              height: 155.h,
              decoration: BoxDecoration(
                color: isDarkMode? AppColors.containers_bgd: AppColors.container,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.third_color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}