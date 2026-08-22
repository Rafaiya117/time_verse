// class UserSession {
//   static final UserSession _instance = UserSession._internal();

//   factory UserSession() {
//     return _instance;
//   }

//   UserSession._internal();

//   String? userId;
//   String? username;
//   String? profileImageUrl;

//   String get formattedUsername {
//     if (username == null || username!.trim().isEmpty) return '';

//     final parts = username!.trim().split(' ');

//     if (parts.length == 1) return username!;

//     final first = parts.first;
//     final rest = parts.sublist(1).join(' ');

//     return '$first\n$rest';
//   }
// }

import 'package:time_verse/config/app_route/app_prefernce.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  String? userId;
  String? username;
  String? profileImageUrl;

  /// Loads saved Google user details into memory on startup
  Future<void> initFromPrefs() async {
    final isGoogle = await AppPrefs.isGoogleLogin();
    if (isGoogle) {
      final googleUser = await AppPrefs.getGoogleUser();
      username = googleUser['name'] ?? username;
      profileImageUrl = googleUser['photo'] ?? profileImageUrl;
    }
  }

  String get formattedUsername {
    if (username == null || username!.trim().isEmpty) return '';
    final parts = username!.trim().split(' ');
    if (parts.length == 1) return username!;

    final first = parts.first;
    final rest = parts.sublist(1).join(' ');

    return '$first\n$rest';
  }
}