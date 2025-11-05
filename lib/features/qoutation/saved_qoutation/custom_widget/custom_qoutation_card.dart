import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
    this.isSelected = false,
    this.onTap,
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.containers_bgd : const Color(0xFFF4F6F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fourth_color),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: Time and Share
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.time,
                      style: GoogleFonts.outfit(
                        color: AppColors.fourth_color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Handle share logic
                      },
                      icon: SvgPicture.asset(
                        widget.shareIconPath,
                        width: 14.w,
                        height: 12.25.h,
                        colorFilter: ColorFilter.mode(
                          isDarkMode ? AppColors.text_color : const Color(0xFF353535),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                // Center Text
                Text(
                  '"${widget.quoteText}"',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '— ${widget.author}',
                      style: GoogleFonts.outfit(
                        color: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B),
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        // Heart Icon
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                          },
                          icon: SvgPicture.asset(
                            isLiked ? widget.heartFilledIconPath : widget.heartIconPath,
                            width: 14.w,
                            height: 11.97.h,
                            colorFilter: ColorFilter.mode(
                              isLiked
                                ? Colors.red
                                : (isDarkMode ? AppColors.text_color : const Color(0xFF353535)),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),

                        // Bookmark Icon
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isBookmarked = !isBookmarked;
                            });
                          },
                          icon: SvgPicture.asset(
                            isBookmarked ? widget.bookmarkFilledIconPath : widget.bookmarkIconPath,
                            width: 10.5.w,
                            height: 14.h,
                            colorFilter: ColorFilter.mode(
                              isBookmarked
                                ? Colors.white
                                : (isDarkMode ? AppColors.text_color : const Color(0xFF353535)),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ✅ Selection Check Icon
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
