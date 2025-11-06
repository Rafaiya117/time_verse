import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class EventController extends ChangeNotifier {
  String quoteText = '"Even the tallest tree\nstarts from a small seed. Your Contribution\nmatters."';

  final GlobalKey quoteShareKey = GlobalKey();

  Future<void> shareQuoteAsImage() async {
    try {
      final boundary = quoteShareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/quote.png').create();
      await file.writeAsBytes(pngBytes);

      // ignore: deprecated_member_use
      await Share.shareXFiles([XFile(file.path)], text: '✨ ${quoteText}');
    } catch (e) {
      debugPrint('⚠️ Error sharing quote: $e');
    }
  }
}
