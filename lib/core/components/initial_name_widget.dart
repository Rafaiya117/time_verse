import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class CustomUserInitialsAvatar extends StatelessWidget {
  final String userFirstName;
  final double size;

  const CustomUserInitialsAvatar({
    super.key,
    required this.userFirstName,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
  String cleanName = userFirstName.trim();
  String firstLetter = cleanName.isNotEmpty ? cleanName[0].toUpperCase() : 'R';
  final String alphabetSvgPath = 'assets/alphabet/$firstLetter.svg';
  
  debugPrint('Loading Avatar Asset Path: ---> "$alphabetSvgPath"');

    return SvgPicture.asset(
      alphabetSvgPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter:ColorFilter.mode(
        Colors.amber,
        BlendMode.srcIn,
      ),
      // Replaced deprecated placeholderBuilder with crisp modern errorBuilder 
      errorBuilder: (context, error, stackTrace) {
        debugPrint('⚠️ Asset Missing or Load Error on: $alphabetSvgPath. Error: $error');
        return SizedBox(
          width: size,
          height: size,
          child: Icon(
            Icons.account_circle,
            size: size,
            color: const Color(0xFFF5B301),
          ),
        );
      },
    );
  }
}