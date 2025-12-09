import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_bottomnav.dart';
import 'package:time_verse/core/components/custom_button.dart';
import 'package:time_verse/core/components/custom_header.dart';
import 'package:time_verse/core/utils/colors.dart';
import 'package:time_verse/features/qoutation/saved_qoutation/controller/saved_qoute_controller.dart';
import 'package:time_verse/features/qoutation/saved_qoutation/custom_widget/custom_qoutation_card.dart';

class SavedQoutation extends StatelessWidget {
  const SavedQoutation({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<SavedQouteController>(context, listen: false);
      controller.fetchSavedQuotes();
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Column(
            children: [
              CustomHeaderBar(
                title: 'The Wisdom Jounal',
                leftSpacing: 50.w,
                rightSpacing: 23.w,
              ),
              SizedBox(height: 20.h,),
              SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    elevation: const WidgetStatePropertyAll<double>(0), 
                    shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
                    controller: controller,
                    hintText: 'Search your wisdom...',
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    leading: Icon(Icons.search, color: isDarkMode?AppColors.text_color:Color(0xFF373F4B),),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side:BorderSide(color: isDarkMode?AppColors.text_color:Color(0xFF373F4B)),
                      ),
                    ),
                    overlayColor: const WidgetStatePropertyAll<Color>(
                      Colors.transparent,
                    ),
                    backgroundColor: const WidgetStatePropertyAll<Color>(
                      Colors.transparent,
                    ),
                    textStyle: const WidgetStatePropertyAll<TextStyle>(
                      TextStyle(color: Colors.white),
                    ),
                    hintStyle:WidgetStatePropertyAll<TextStyle>(
                      TextStyle(color: isDarkMode?AppColors.text_color:AppColors.heading_color),
                    ),
                  );
                },
                suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                    final query = controller.value.text.toLowerCase();
                      final quoteController = Provider.of<SavedQouteController>(context,listen: false,);
                      final filteredQuotes = quoteController.savedQuotes
                        .where((quote) =>quote['quoteText']!.toLowerCase().contains(query,) ||
                        quote['author']!.toLowerCase().contains(query),).toList();
                      return List<ListTile>.generate(filteredQuotes.length, (int index,) {
                        final quote = filteredQuotes[index];
                      return ListTile(
                        title: Text(
                        quote['quoteText']!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(quote['author']!),
                      onTap: () {
                        controller.closeView(quote['quoteText']!);
                      },
                    );
                  });
                },
              ),
              SizedBox(height: 20.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<SavedQouteController>(
                    builder: (context, controller, _) {
                      return Text(
                        '${controller.savedQuotes.length} quotes saved',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp,
                          color: AppColors.third_color,
                        ),
                      );
                    },
                  ),
                  CustomButton(
                    text: "Share All",
                    onPressed: () {
                      final controller = Provider.of<SavedQouteController>(context, listen: false);
                      controller.selectAllQuotes();
                      controller.shareSelectedQuotes(context);
                    },
                    leadingIcon: SvgPicture.asset(
                      'assets/icons/share_filled.svg',
                      width: 14.w,
                      height: 12.25.h,
                      colorFilter: ColorFilter.mode(
                        AppColors.text_color,
                        BlendMode.srcIn,
                      ),
                    ),
                    solidColor: AppColors.fourth_color,
                    textColor: AppColors.text_color,
                    fontFamily: 'outfit',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 38.h,
                    width: 112.19.w,
                 ),
                ],
              ),
              SizedBox(height: 20.h,),
              Consumer<SavedQouteController>(
                builder: (context, controller, _) {
                  return Column(
                    children: controller.savedQuotes.map((quote) {    
                      debugPrint("Quote ID: ${quote['id']}");
                      return Column(
                        children: [
                          QuoteCardWidget(
                            time: quote['time'] ?? '',
                            quoteText: quote['description'] ?? '',
                            author: quote['author'] ?? '',
                            shareIconPath: 'assets/icons/share.svg',
                            heartIconPath: 'assets/icons/heart.svg',
                            heartFilledIconPath:'assets/icons/heart_filled.svg',
                            bookmarkIconPath: 'assets/icons/bookmark.svg',
                            bookmarkFilledIconPath:'assets/icons/bookmark_filled.svg',
                            id: quote['id'] as int,
                            onHeartTap: () {
                              print("Heart clicked: ${quote['id']}");
                            },
                            onBookmarkTap: () {
                              final int id = (quote['id'] as int?) ?? 0;
                              controller.toggleQuoteSelection(id);                           
                              print("Bookmark clicked: ${quote['id']}");
                            },
                          ),
                          SizedBox(height: 10.h),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
              // SizedBox(height: 10.h),
              // Center(
              //   child: CustomButton(
              //     text: "Add New Event",
              //     onPressed: () {
              //       //context.push('/signup');
              //       context.push('/settings');
              //     },
              //     gradient: AppGradientColors.button_gradient,
              //     textColor: AppColors.text_color,
              //     fontFamily: 'outfit',
              //     fontSize: 16.sp,
              //     fontWeight: FontWeight.normal,
              //     height: 51.h,
              //     width: double.infinity,
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:Consumer<SavedQouteController>(
        builder: (context, controller, _) => CustomBottomNavBar(),
      ),
    );
  }
}