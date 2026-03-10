import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:time_verse/config/app_route/app_prefernce.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 3));

    final isFirstLaunch = await AppPrefs.isFirstLaunch();
    final isLoggedIn = await AppPrefs.isLoggedIn();
    final isGoogleLogin = await AppPrefs.isGoogleLogin();
    final googleToken = isGoogleLogin ? await AppPrefs.getGoogleToken() : null;

    if (!mounted) return;

    final shouldForceLogin = isGoogleLogin && (googleToken == null || googleToken.isEmpty);

    if (isFirstLaunch) {
      await AppPrefs.setFirstLaunch(false);
      context.push('/landing');
    } else if (isLoggedIn && !shouldForceLogin) {
      context.push('/home'); // user has valid token
    } else {
      // Clear invalid Google login state
      await AppPrefs.setGoogleLogin(false);
      await AppPrefs.clearGoogleToken();
      await AppPrefs.setLoggedIn(false);

      context.push('/login'); // send to login
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String logoAsset =
        isDarkMode ? 'assets/images/logo.png' : 'assets/images/logo_light.png';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Center(
          child: Image.asset(
            logoAsset,
            width: 268.w,
            height: 263.h,
          ),
        ),
      ),
    );
  }
}