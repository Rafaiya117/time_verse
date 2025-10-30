import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_bottomnav.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/components/custom_settings_section.dart';
import 'package:time_verse/features/settings/log_out_modal.dart';
import 'package:time_verse/features/settings/settings_controller.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
        child: Column(
          children: [
            CustomHeaderBar(
              title: 'Settings',
              leftSpacing: 100.w,
              rightSpacing: 83.w,
            ),
            SizedBox(height: 20.h),
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
        builder: (context, controller, _) => CustomBottomNavBar(),
      ),
    );
  }
}