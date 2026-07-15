import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/bottom_card_controller/bottom_card_controller.dart';
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
  NavItem(label: 'Calendar', iconPath: 'assets/icons/calender.svg', route: '/calendar'),
  NavItem(label: 'Add', iconPath: 'assets/icons/add_icon.svg', route: '/add'),
  NavItem(label: 'Saved', iconPath: 'assets/icons/save.svg', route: '/saved'),
  NavItem(label: 'Settings', iconPath: 'assets/icons/setting.svg', route: '/settings'),
];

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<NavItem> standardItems = [
      navItems[0], // Home
      navItems[1], // Calendar
      navItems[3], // Saved
      navItems[4], // Settings
    ];

    //final addItem = navItems.firstWhere((item) => item.label == 'Add');

    return Consumer<BottomNavController>(
      builder: (context, controller, _) {
        final selectedIndex = controller.selectedIndex;

        return SizedBox(
          height: 100.h,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding:EdgeInsets.only(bottom: 10.h),
                child: Container(
                    height: 64.h,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.containers_bgd : Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: isDark
                          ? AppColors.text_color
                          : AppColors.heading_color,
                          width: 0.4,
                        ),
                      ),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(standardItems.length, (index) {
                        final item = standardItems[index];
                        final originalIndex = navItems.indexOf(item);
                        final isSelected = originalIndex == selectedIndex;
                
                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              debugPrint(
                                'Tapped index: $originalIndex (${item.label})',
                              );
                              controller.navigateTo(originalIndex, context);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  item.iconPath,
                                  width: 24.w,
                                  height: 24.h,
                                  colorFilter: ColorFilter.mode(
                                    isSelected ? AppColors.fourth_color
                                    : (isDark? Colors.white: const Color(0xFF636363)),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  item.label,
                                  style: GoogleFonts.inter(
                                    fontSize: 10.2.sp,
                                    fontWeight: FontWeight.normal,
                                    color: isSelected
                                    ? AppColors.fourth_color: (isDark? Colors.white: const Color(0xFF636363)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
              ),
              Positioned(
                bottom: 65.h,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    debugPrint(
                      'SUCCESS: Tapped floating action button (Pushing Add Page)',
                    );
                    context.push('/add');
                  },
                  child: Container(
                    width: 58.w,
                    height: 58.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFA500),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.w),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}