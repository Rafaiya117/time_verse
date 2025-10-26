import 'package:flutter/material.dart';

class ThemedBackgroundWrapper extends StatelessWidget {
  final Widget child;
  const ThemedBackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    //!-------- Check current brightness -------------!
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String backgroundAsset = isDarkMode
        ? 'assets/images/bg_dark4.png' 
        : 'assets/images/bg_light.png';
    return Stack(
      children: <Widget>[
        //!-------- Background Image ---------
        Positioned.fill(
          child: Image.asset(
            backgroundAsset,
            fit: BoxFit.cover, 
          ),
        ),
        //!------------Scafolled --------------!
        child,
      ],
    );
  }
}