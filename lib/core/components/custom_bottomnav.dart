import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/core/utils/colors.dart';

class NavItem {
  final String label;
  final String iconPath;
  final String route;

  NavItem({
    required this.label,
    required this.iconPath,
    required this.route,
  });
}

final List<NavItem> navItems = [
  NavItem(label: 'Home', iconPath: 'assets/icons/home.svg', route: '/home'),
  NavItem(label: 'Calendar', iconPath: 'assets/icons/calendar.svg', route: '/calendar'),
  NavItem(label: 'Add', iconPath: 'assets/icons/add.svg', route: '/add'),
  NavItem(label: 'Saved', iconPath: 'assets/icons/bookmark.svg', route: '/saved'),
  NavItem(label: 'Settings', iconPath: 'assets/icons/settings.svg', route: '/settings'),
];

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final item = navItems[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => context.push(item.route),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  item.iconPath,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColors.fourth_color : AppColors.text_color,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.label,
                  style: GoogleFonts.inter(
                    fontSize: 10.2.sp,
                    fontWeight: FontWeight.normal,
                    color: isSelected ? AppColors.fourth_color : AppColors.text_color,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
