import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/bottom_card_controller/bottom_card_controller.dart';
import 'package:time_verse/core/utils/colors.dart';

// class NavItem {
//   final String label;
//   final String iconPath;
//   final String route;

//   NavItem({
//     required this.label,
//     required this.iconPath,
//     required this.route,
//   });
// }

// final List<NavItem> navItems = [
//   NavItem(label: 'Home', iconPath: 'assets/icons/home.svg', route: '/home'),
//   NavItem(label: 'Calendar', iconPath: 'assets/icons/calender.svg', route: '/calendar'),
//   NavItem(label: 'Add', iconPath: 'assets/icons/add_icon.svg', route: '/add'),
//   NavItem(label: 'Saved', iconPath: 'assets/icons/save.svg', route: '/saved'),
//   NavItem(label: 'Settings', iconPath: 'assets/icons/setting.svg', route: '/settings'),
// ];

// class CustomBottomNavBar extends StatelessWidget {
//   const CustomBottomNavBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Consumer<BottomNavController>(
//       builder: (context, controller, _) {
//         final selectedIndex = controller.selectedIndex;

//         return Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Container(
//               height: 71.h,
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               decoration: BoxDecoration(
//                 border: Border(top: BorderSide(color: isDark?AppColors.text_color:AppColors.heading_color,width: 0.4)),
//                 color: isDark ? AppColors.containers_bgd : AppColors.l_bottom_nav,
//                 boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: List.generate(navItems.length, (index) {
//                   final item = navItems[index];
//                   final isSelected = index == selectedIndex;
//                   final isAddIcon = item.label == 'Add';

//                   return GestureDetector(
//                     behavior:HitTestBehavior.opaque, // ✅ make whole area tappable
//                     onTap: () {
//                       debugPrint('Tapped index: $index (${item.label})');
//                       controller.navigateTo(index, context);
//                     },
//                     child: isAddIcon
//                       ? SizedBox(
//                         width: 60.w,
//                         height: 100.h,
//                         child: Stack(
//                           clipBehavior: Clip.none,
//                             alignment: Alignment.center,
//                             children: [
//                               Positioned(
//                                 top: -30.h,
//                                 child: SvgPicture.asset(
//                                   item.iconPath,
//                                   width: 50.w,
//                                   height: 70.h,
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: 8,
//                                   child: Text(
//                                     item.label,
//                                     style: GoogleFonts.inter(
//                                       fontSize: 10.2.sp,
//                                       fontWeight: FontWeight.normal,
//                                       color: isSelected
//                                         ? AppColors.fourth_color
//                                         : AppColors.text_color,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         SvgPicture.asset(
//                           item.iconPath,
//                           width: 24.w,
//                           height: 24.h,
//                           colorFilter: ColorFilter.mode(
//                           isSelected
//                             ? AppColors.fourth_color
//                             : AppColors.text_color,
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                       SizedBox(height: 4.h),
//                       Text(
//                         item.label,
//                         style: GoogleFonts.inter(
//                           fontSize: 10.2.sp,
//                           fontWeight: FontWeight.normal,
//                           color: isSelected
//                             ? AppColors.fourth_color
//                             : AppColors.text_color,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

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

    // Separate the standard 4 background items from the floating button layer
    final List<NavItem> standardItems = [
      navItems[0], // Home
      navItems[1], // Calendar
      navItems[3], // Saved
      navItems[4], // Settings
    ];

    final addItem = navItems.firstWhere((item) => item.label == 'Add');

    return Consumer<BottomNavController>(
      builder: (context, controller, _) {
        final selectedIndex = controller.selectedIndex;

        return SizedBox(
          height: 100.h, 
          child: Stack(
            clipBehavior: Clip.none, 
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 64.h,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color:isDark? AppColors.containers_bgd : Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: isDark ? AppColors.text_color : AppColors.heading_color,
                      width: 0.4,
                    ),
                  ),
                  //color: isDark ? AppColors.containers_bgd : AppColors.l_bottom_nav,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                    )
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
                          debugPrint('Tapped index: $originalIndex (${item.label})');
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
                                isSelected? AppColors.fourth_color
                                : (isDark ? Colors.white : const Color(0xFF636363)
                                ),
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
                                  ? AppColors.fourth_color
                                  : (isDark ? Colors.white
                                  : const Color(0xFF636363)
                                ), // Retains fourth_color if selected; otherwise checks dark mode
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Positioned(
                bottom: 65.h, 
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    final int addIndex = navItems.indexOf(addItem);
                    debugPrint('SUCCESS: Tapped floating action index: $addIndex (Add Page)');
                    
                    // Update index selection state inside your controller layout manager
                    controller.navigateTo(addIndex, context);
                    
                    // Use go to clear underlying route stacks and prevent backward overlay transparency issues
                    context.go(addItem.route);
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
                          border: Border.all(
                            color: Colors.white, 
                            width: 2.w,
                          ),
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