import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/config/app_route/app_prefernce.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // ignore: deprecated_member_use
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: SizedBox(
          width: 327.w,
          height: 218.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/delete_icon_dark.svg',
                width: 30.w,
                height: 30.h,
              ),
              SizedBox(height: 20.h),
              Text(
                'Logout',
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.text_color
                      : const Color(0xFF373F4B),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Are you sure you want to Log Out?\nThis action cannot be undone. Are you sure you want to continue?',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.text_color
                    : const Color(0xFF373F4B),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await AppPrefs.setLoggedIn(false);
                        await AuthService().clearToken();
                        context.push('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Log Out',
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
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
