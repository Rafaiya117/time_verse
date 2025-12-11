import 'dart:async';
import 'package:app_links/app_links.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription? _sub;

  Future<void> init() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) _handleDeepLink(initialUri);
    } catch (e) {
      print("Failed to get initial link: $e");
    }

    _sub = _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) _handleDeepLink(uri);
      },
      onError: (err) {
        print("Deep link error: $err");
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    print("DeepLink received: $uri");

    final code = uri.queryParameters['code'];
    if (code != null) {
      print("OAuth Authorization Code: $code");
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
