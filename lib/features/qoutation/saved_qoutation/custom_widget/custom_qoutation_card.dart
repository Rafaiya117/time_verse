import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:time_verse/core/utils/colors.dart';

class QuoteCardWidget extends StatefulWidget {
  final String time;
  final String quoteText;
  final String author;
  final String shareIconPath;
  final String heartIconPath;
  final String heartFilledIconPath;
  final String bookmarkIconPath;
  final String bookmarkFilledIconPath;

  // ✅ Optional selection state
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onHeartTap; // for heart
  final VoidCallback? onBookmarkTap; // new for bookmark
  final int id;

  const QuoteCardWidget({
    super.key,
    required this.time,
    required this.quoteText,
    required this.author,
    required this.shareIconPath,
    required this.heartIconPath,
    required this.heartFilledIconPath,
    required this.bookmarkIconPath,
    required this.bookmarkFilledIconPath,
    required this.id,
    this.isSelected = false,
    this.onTap,
    this.onHeartTap,
    this.onBookmarkTap, // added
  });

  @override
  State<QuoteCardWidget> createState() => _QuoteCardWidgetState();
}

class _QuoteCardWidgetState extends State<QuoteCardWidget> {
  bool isLiked = false;
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias, // Ensures the bottom actions row conforms to the border radius
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.containers_bgd : const Color(0xFFF4F6F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fourth_color),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Section Padding Container
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date / Time header row
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/calender_2.svg',
                            width:20.w,
                            height: 15.h,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            () {
                              try {
                                DateTime parsedDate = DateTime.parse(widget.time,).toLocal();
                                return DateFormat(
                                "MMM d, yyyy '•' h:mm a",
                                ).format(parsedDate);
                              } catch (e) {
                                return widget.time; // Fallback to raw string if parsing fails
                              }
                            }(),
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFFFB703),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Elegant Styled Big Quotation Mark
                      Text(
                        '“',
                        style: GoogleFonts.playfairDisplay(
                          color: AppColors.fourth_color,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          height: 0.6,
                        ),
                      ),

                      // Quote Content Body Text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          widget.quoteText,
                          style: GoogleFonts.playfairDisplay(
                            color: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B),
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Author Row Signature
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '— ${widget.author}',
                          style: GoogleFonts.outfit(
                            color: AppColors.fourth_color,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Bottom Actions Row Bar (Divided symmetrically with borders)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.fourth_color.withOpacity(0.2)),
                    ),
                  ),
                  height: 52,
                  child: Row(
                    children: [
                      // Action Component 1: Favorite Button
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                            if (widget.onHeartTap != null) widget.onHeartTap!();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                isLiked ? widget.heartFilledIconPath : widget.heartIconPath,
                                width: 16.w,
                                height: 14.h,
                                colorFilter: ColorFilter.mode(
                                  isLiked ? Colors.red: (isDarkMode ? AppColors.text_color : AppColors.fourth_color),
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Favorite',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: isDarkMode ? AppColors.text_color : AppColors.fourth_color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Vertical separator line
                      VerticalDivider(color: AppColors.fourth_color.withOpacity(0.2), width: 1, thickness: 1),

                      // Action Component 2: Save Button
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isBookmarked = !isBookmarked;
                            });
                            if (widget.onBookmarkTap != null) widget.onBookmarkTap!();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                isBookmarked ? widget.bookmarkFilledIconPath : widget.bookmarkIconPath,
                                width: 13.w,
                                height: 16.h,
                                colorFilter: ColorFilter.mode(
                                  isBookmarked ? AppColors.fourth_color
                                  : (isDarkMode ? AppColors.text_color : AppColors.fourth_color),
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Save',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: isDarkMode ? AppColors.text_color : AppColors.fourth_color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Vertical separator line
                      VerticalDivider(color: AppColors.fourth_color.withOpacity(0.2), width: 1, thickness: 1),

                      // Action Component 3: Share Button
                      Expanded(
                        child: InkWell(
                          onTap: () {}, // Kept share functionality unchanged as per requirement
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                widget.shareIconPath,
                                width: 16.w,
                                height: 14.h,
                                colorFilter: ColorFilter.mode(
                                  isDarkMode ? AppColors.text_color : AppColors.fourth_color,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Share',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: isDarkMode ? AppColors.text_color : AppColors.fourth_color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ✅ Keep Selection Overlay Checkmark logic exactly where it belongs
          if (widget.isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.fourth_color,
                child: Icon(Icons.check, size: 16, color: AppColors.text_color),
              ),
            ),
        ],
      ),
    );
  }
}