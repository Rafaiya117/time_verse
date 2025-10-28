import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                SizedBox(width: 60.w,),
                Text(
                  'Terms & Condition',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: isDarkMode? AppColors.text_color: AppColors.heading_color,
                  ),
                ),
                SizedBox(width: 40.w,),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: isDarkMode
                      ? AppColors.text_color
                      : const Color(0xFF373F4B),
                    ),
                  children: [
                    TextSpan(
                      text:'Clause \n\n',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                        color: isDarkMode? AppColors.text_color:Color(0xFF373F4B)
                      ),
                    ),
                    TextSpan(
                      text:'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.\n\n',
                    ),
                    TextSpan(
                      text:'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.\n',
                    ),
                    TextSpan(
                      text:'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.\n',
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value:false,
                  onChanged: (bool? value){},
                  activeColor: AppColors.third_color,
                  materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                ),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.normal,
                      fontSize: 14.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.text_color
                        : AppColors.heading_color,
                    ),
                    children: [
                      TextSpan(text: 'I agree to '),
                      TextSpan(
                        text: 'Terms & Condition',
                        style: TextStyle(color: AppColors.fourth_color),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy\n Policy',
                        style: TextStyle(color: AppColors.fourth_color),
                      ),
                      // TextSpan(text: '\n'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}