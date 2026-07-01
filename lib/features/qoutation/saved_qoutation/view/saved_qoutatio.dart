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
  SavedQoutation({super.key});
  
  final GlobalKey _boundaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<SavedQouteController>(context, listen: false);
      controller.fetchSavedQuotes();
    });
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Column(
            children: [
              CustomHeaderBar(
                title: 'The Wisdom Journal',
                leftSpacing: 50.w,
                rightSpacing: 23.w,
              ),
              SizedBox(height: 20.h,),
              SearchAnchor(
                // 🛠️ FIX: Listens to text updates/keystrokes when the full-screen search view overlay is active
                viewOnChanged: (value) {
                  Provider.of<SavedQouteController>(context, listen: false).updateSearchQuery(value);
                },
                builder: (BuildContext context, SearchController searchController) {
                  return SearchBar(
                    elevation: const WidgetStatePropertyAll<double>(0), 
                    shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
                    controller: searchController,
                    hintText: 'Search your wisdom...',
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    leading: Icon(Icons.search, color: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B)),
                    onTap: () {
                      searchController.openView();
                    },
                    onChanged: (value) {
                      // Listens to text updates when typing directly in collapsed layout bar
                      Provider.of<SavedQouteController>(context, listen: false).updateSearchQuery(value);
                    },
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B)),
                      ),
                    ),
                    overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      isDarkMode ? Colors.transparent : const Color(0xFFDADADA).withOpacity(0.3),
                    ),
                    textStyle: const WidgetStatePropertyAll<TextStyle>(TextStyle(color: Colors.white)),
                    hintStyle: WidgetStatePropertyAll<TextStyle>(
                      TextStyle(color: isDarkMode ? AppColors.text_color : AppColors.heading_color),
                    ),
                  );
                },
                suggestionsBuilder: (BuildContext context, SearchController searchController) {
                  final quoteController = Provider.of<SavedQouteController>(context, listen: false);
                  final suggestions = quoteController.filteredQuotes;

                  return List<ListTile>.generate(suggestions.length, (int index) {
                    final quote = suggestions[index];
                    final displayQuote = quote['description'] ?? '';
                    return ListTile(
                      title: Text(
                        displayQuote,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(quote['author'] ?? ''),
                      onTap: () {
                        searchController.closeView(displayQuote);
                        quoteController.updateSearchQuery(displayQuote);
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
                        '${controller.filteredQuotes.length} quotes saved',
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
                      controller.shareQuotesAsImage(_boundaryKey);
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
              
              RepaintBoundary(
                key: _boundaryKey,
                child: Container(
                  color: isDarkMode ? const Color(0xFF0F172A) : Colors.white,
                  child: Consumer<SavedQouteController>(
                    builder: (context, controller, _) {
                      return Column(
                        children: controller.filteredQuotes.map((quote) {    
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
                ),
              ),
              SizedBox(height: 120.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<SavedQouteController>(
        builder: (context, controller, _) => const CustomBottomNavBar(),
      ),
    );
  }
}