import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double percentage; // e.g., 75 for 75%
  final double barHeight;
  final Color progressColor;
  final Color backgroundColor;

  const ProgressIndicatorWidget({
    super.key,
    required this.percentage,
    this.barHeight = 20.0,
    this.progressColor = Colors.orange,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (percentage.clamp(0, 100)) / 100;

    return SizedBox(
      width: 172,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            //!---------blurred background----------!
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: barHeight,
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.1),
              ),
            ),

            //!----------Progress with solid color---------!
            LinearPercentIndicator(
              lineHeight: barHeight,
              percent: progress,
              backgroundColor: Colors.transparent,
              barRadius: const Radius.circular(8),
              padding: EdgeInsets.zero,
              progressColor: progressColor,
            ),
          ],
        ),
      ),
    );
  }
}