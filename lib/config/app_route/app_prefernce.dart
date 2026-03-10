import 'package:shared_preferences/shared_preferences.dart';

// class AppPrefs {
//   static const _isLoggedInKey = 'is_logged_in';
//   static const _isFirstLaunchKey = 'is_first_launch';
//   static const _rememberMeKey = 'remember_me';
//   static const _savedEmailKey = 'saved_email';
//   static const _savedPasswordKey = 'saved_password';
//   static const _isGoogleLoginKey = 'is_google_login';

//   /// ✅ Login persistence
//   static Future<void> setLoggedIn(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_isLoggedInKey, value);
//   }

//   static Future<bool> isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_isLoggedInKey) ?? false;
//   }

//   /// ✅ Google login persistence
//   static Future<void> setGoogleLogin(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_isGoogleLoginKey, value);
//   }

//   static Future<bool> isGoogleLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_isGoogleLoginKey) ?? false;
//   }

//   /// ✅ Landing page shown only first time
//   static Future<bool> isFirstLaunch() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_isFirstLaunchKey) ?? true;
//   }

//   static Future<void> setFirstLaunch(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_isFirstLaunchKey, value);
//   }

//   /// ✅ Remember Me
//   static Future<void> saveRememberMe(bool remember,String email,String password,) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_rememberMeKey, remember);
//     if (remember) {
//       await prefs.setString(_savedEmailKey, email);
//       await prefs.setString(_savedPasswordKey, password);
//     } else {
//       await prefs.remove(_savedEmailKey);
//       await prefs.remove(_savedPasswordKey);
//     }
//   }

//   static Future<Map<String, dynamic>> getRememberedUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     return {
//       'remember': prefs.getBool(_rememberMeKey) ?? false,
//       'email': prefs.getString(_savedEmailKey),
//       'password': prefs.getString(_savedPasswordKey),
//     };
//   }
// }
class AppPrefs {
  static const _isLoggedInKey = 'is_logged_in';
  static const _isFirstLaunchKey = 'is_first_launch';
  static const _rememberMeKey = 'remember_me';
  static const _savedEmailKey = 'saved_email';
  static const _savedPasswordKey = 'saved_password';
  static const _isGoogleLoginKey = 'is_google_login';

  // ✅ ADDED: Google user info keys
  static const _googleUserNameKey = 'google_user_name';
  static const _googleUserEmailKey = 'google_user_email';

  /// ✅ Login persistence
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// ✅ Google login persistence
  static Future<void> setGoogleLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isGoogleLoginKey, value);
  }

  static Future<bool> isGoogleLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isGoogleLoginKey) ?? false;
  }

  /// ✅ ADDED: Save Google user info
  static Future<void> saveGoogleUser(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_googleUserNameKey, name);
    await prefs.setString(_googleUserEmailKey, email);
  }

  /// ✅ ADDED: Get Google user info
  static Future<Map<String, String?>> getGoogleUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_googleUserNameKey),
      'email': prefs.getString(_googleUserEmailKey),
    };
  }

  /// ✅ Landing page shown only first time
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstLaunchKey) ?? true;
  }

  static Future<void> setFirstLaunch(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstLaunchKey, value);
  }

  /// Save Google server token
static Future<void> saveGoogleToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('google_token', token);
}

static Future<String?> getGoogleToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('google_token');
}

static Future<void> clearGoogleToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('google_token');
}
  /// ✅ Remember Me
  static Future<void> saveRememberMe(
    bool remember,
    String email,
    String password,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, remember);

    if (remember) {
      await prefs.setString(_savedEmailKey, email);
      await prefs.setString(_savedPasswordKey, password);
    } else {
      await prefs.remove(_savedEmailKey);
      await prefs.remove(_savedPasswordKey);
    }
  }

  static Future<Map<String, dynamic>> getRememberedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'remember': prefs.getBool(_rememberMeKey) ?? false,
      'email': prefs.getString(_savedEmailKey),
      'password': prefs.getString(_savedPasswordKey),
    };
  }
}