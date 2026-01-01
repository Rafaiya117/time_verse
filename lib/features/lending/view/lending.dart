import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      body:Padding(
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
              'Turn your Future Schedule into wisdom',
              style: GoogleFonts.greatVibes(
                fontSize: 20.sp,
                fontWeight: FontWeight.normal,
                color: primaryTextColor,
              ),
            ),
            SizedBox(height: 20.h,),
            Text(
              'Infini Quote',
              style:GoogleFonts.jacquesFrancoisShadow(
                fontWeight: FontWeight.normal,
                fontSize: 52.sp,
                color: secondaryTextColor
              ) ,
            ),
            SizedBox(height: 10.h,),
            Text(
              'Connect your daily journey with\n cosmic wisdom and divine\n guidance',
              textAlign: TextAlign.center,
              style:GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                fontSize: 15.3.sp,
                color: AppColors.secendary_text_color
              ) ,
            ),
            SizedBox(height: 20.h,),
            CustomButton(
              text: "Begin Your Journey",
              onPressed: () {
                context.push('/signup');
              },
              gradient: AppGradientColors.button_gradient,
              textColor: AppColors.text_color,
              fontFamily: 'inter',
              fontSize: 13.6.sp,
              fontWeight: FontWeight.w500,
              height: 48.h,
              width: 219.48.w,
            ),
            SizedBox(height: 10.h,),
            TextButton(
              onPressed: (){},
              child: Text(
                'Swipe up to explore',
                style: GoogleFonts.inter(
                  fontSize: 11.9.sp,
                  fontWeight: FontWeight.normal,
                  color: AppColors.secendary_text_color
                ),
              ), 
            ),
            SizedBox(height: 20.h,),
            SizedBox(
              width: 142.w,
              child: ProgressIndicatorWidget(
                barHeight: 4,
                percentage: 100,
                progressColor: AppColors.third_color,
              ),
            ),
          ],
        ),
      ) ,
    );
  }
}