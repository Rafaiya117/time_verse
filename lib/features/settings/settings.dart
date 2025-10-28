import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_bottomnav.dart';
import 'package:time_verse/core/components/custom_settings_section.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/settings/log_out_modal.dart';
import 'package:time_verse/features/settings/settings_controller.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final location = GoRouterState.of(context).uri.toString();
    final controller = Provider.of<SettingsController>(context, listen: false);
    controller.updateIndexFromRoute(location);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
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
                SizedBox(width: 100.w,),
                Text(
                  'Settings',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: isDarkMode? AppColors.text_color: AppColors.heading_color,
                  ),
                ),
                SizedBox(width: 83.w,),
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
            SettingsSection(
              title: 'Account',
              items: [
                SettingsItem(
                  label: 'Profile',
                  onTap: () => context.push('/profile'),
                ),
                SettingsItem(
                  label: 'Change Password',
                  onTap: () => context.push('/change_password'),
                ),
              ],
            ),
            SettingsSection(
              title: 'Support & Legal',
              items: [
                SettingsItem(
                  label: 'Privacy Policy',
                  onTap: () => context.push('/privacy_policy'),
                ),
                SettingsItem(
                  label: 'Terms & Conditions',
                  onTap: () => context.push('/terms_and_condition'),
                ),
              ],
            ),
            SettingsSection(
              title: 'Account Actions',
              items: [
                SettingsItem(
                  label: 'Subscription',
                  onTap: () => context.push('/subscription'),
                ),
                SettingsItem(
                  label: 'Delete Account',
                  onTap: () => context.push('/delete_account'),
                ),
                SettingsItem(
                  label: 'Logout',
                  onTap: () => showLogoutDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Consumer<SettingsController>(
        builder: (context, controller, _) => CustomBottomNavBar(
          selectedIndex: controller.selectedIndex,
        ),
      ),
    );
  }
}