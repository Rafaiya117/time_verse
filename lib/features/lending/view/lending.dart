import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/prograss_bar.dart';
import 'package:time_verse/core/utils/colors.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String logoAsset = isDarkMode
        ? 'assets/images/logo.png' 
        : 'assets/images/logo_light.png';

    final Color primaryTextColor = AppColors.getDynamicTextColor(context); 
    final Color secondaryTextColor = isDarkMode 
        ? AppColors.text_color 
        : AppColors.l_text_clr;
        
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // Ensures the entire screen area detects the gesture
        onVerticalDragEnd: (details) {
          // 2. A negative primaryVelocity means the user dragged/swiped UP
          if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
            context.push('/login');
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    logoAsset,
                    width:268.w,
                    height: 263.h,
                  ),
                ),
                SizedBox(height: 20.h,),
                Text(
                  'Welcome to',
                  style: GoogleFonts.playfair(
                    fontSize: 27.sp,
                    fontWeight: FontWeight.normal,
                    color: primaryTextColor,
                  ),
                ),
                SizedBox(height: 10.h,),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.playfair(
                      fontWeight: FontWeight.bold,
                      fontSize: 52.sp,
                    ),
                    children: [
                      TextSpan(
                        text: 'Infini',
                        style: TextStyle(color: secondaryTextColor),
                      ),
                      TextSpan(
                        text: 'Quote',
                        style: TextStyle(
                          color: Color(0xFFE19B00),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Guiding your daily journey with calm, clarity, and intention.',
                  textAlign: TextAlign.center,
                  style:GoogleFonts.inter(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.3.sp,
                    color: AppColors.text_color
                  ) ,
                ),
                SizedBox(height: 20.h,),
                CustomButton(
                  text: "Start Your Journey",
                  onPressed: () {
                    context.push('/signup');
                  },
                  gradient: AppGradientColors.button_gradient,
                  textColor: Color(0xFF000000),
                  fontFamily: 'inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  height: 48.h,
                  width: 219.48.w,
                ),
                SizedBox(height: 80.h,),
                SizedBox(
                  width: 142.w,
                  child: ProgressIndicatorWidget(
                    barHeight: 4,
                    percentage: 100,
                    progressColor: AppColors.third_color,
                  ),
                ),
                SizedBox(height: 20.h,),
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/swipe_up.svg',
                      width: 24.w,
                      height: 24.h,
                    ),
                    SizedBox(height: 8.h,),
                    TextButton(
                      // 3. Make the text button also navigate to login when tapped
                      onPressed: () {
                        context.push('/login'); 
                      },
                      child: Text(
                        'Swipe up to dismiss',
                        style: GoogleFonts.inter(
                          fontSize: 11.9.sp,
                          fontWeight: FontWeight.normal,
                          color: AppColors.secendary_text_color
                        ),
                      ), 
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}