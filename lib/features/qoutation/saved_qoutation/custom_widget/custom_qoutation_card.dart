// ignore_for_file: deprecated_member_use

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

  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onHeartTap;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onShareTap;
  final GlobalKey boundaryKey;
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
    required this.boundaryKey,
    this.isSelected = false,
    this.onTap,
    this.onHeartTap,
    this.onBookmarkTap,
    this.onShareTap,
  });

  @override
  State<QuoteCardWidget> createState() => _QuoteCardWidgetState();
}

class _QuoteCardWidgetState extends State<QuoteCardWidget> {
  bool isLiked = false;
  bool isBookmarked = false;

  String _getBackgroundImagePath(bool isDarkMode) {
    const totalImages = 5;
    final imageIndex = (widget.id.abs() % totalImages) + 1;
    final prefix = isDarkMode ? 'db' : 'wb';
    return 'assets/ai_generated_img/${prefix}_$imageIndex.png';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgImagePath = _getBackgroundImagePath(isDarkMode);

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fourth_color),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. RepaintBoundary wraps ONLY the card background + quote body content
                RepaintBoundary(
                  key: widget.boundaryKey,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          bgImagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/calender_2.svg',
                                  width: 20.w,
                                  height: 15.h,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  () {
                                    try {
                                      DateTime parsedDate = DateTime.parse(widget.time).toLocal();
                                      return DateFormat("MMM d, yyyy '•' h:mm a").format(parsedDate);
                                    } catch (e) {
                                      return widget.time;
                                    }
                                  }(),
                                  style: GoogleFonts.playfair(
                                    color: const Color(0xFFFFB703),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '“',
                              style: GoogleFonts.playfairDisplay(
                                color: AppColors.fourth_color,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                height: 0.6,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                widget.quoteText,
                                style: GoogleFonts.cormorant(
                                  color: isDarkMode ? AppColors.text_color : const Color(0xFF373F4B),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
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
                    ],
                  ),
                ),

                // 2. Action buttons sit OUTSIDE the RepaintBoundary
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.containers_bgd.withOpacity(0.85)
                        : const Color(0xFFF4F6F5).withOpacity(0.85),
                    border: Border(
                      top: BorderSide(color: AppColors.fourth_color.withOpacity(0.2)),
                    ),
                  ),
                  height: 52,
                  child: Row(
                    children: [
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
                                  isLiked
                                      ? Colors.red
                                      : (isDarkMode ? AppColors.text_color : AppColors.fourth_color),
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
                      VerticalDivider(color: AppColors.fourth_color.withOpacity(0.2), width: 1, thickness: 1),
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
                                  isBookmarked
                                      ? AppColors.fourth_color
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
                      VerticalDivider(color: AppColors.fourth_color.withOpacity(0.2), width: 1, thickness: 1),
                      Expanded(
                        child: InkWell(
                          onTap: widget.onShareTap,
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