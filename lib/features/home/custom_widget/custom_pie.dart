import 'package:flutter/material.dart';
import 'dart:ui'; // Needed for Path

// class CustomPolygonClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     // The SVG viewBox is 178x155. The coordinates need to be scaled
//     // relative to the current size.
//     final double scaleX = size.width / 178.0;
//     final double scaleY = size.height / 155.0;

//     // Helper function to scale coordinates
//     Offset scale(double x, double y) {
//       return Offset(x * scaleX, y * scaleY);
//     }

//     final path = Path();

//     // 1. Move to starting point (M 86.0947 154.421)
//     path.moveTo(scale(86.0947, 154.421).dx, scale(86.0947, 154.421).dy);

//     // 2. Cubic Bézier Curve (C 86.0947 154.421 4.81987 45.1428 2.09089 39.2807)
//     path.cubicTo(
//       scale(86.0947, 154.421).dx, scale(86.0947, 154.421).dy,
//       scale(4.81987, 45.1428).dx, scale(4.81987, 45.1428).dy,
//       scale(2.09089, 39.2807).dx, scale(2.09089, 39.2807).dy,
//     );

//     // 3. Cubic Bézier Curve (C -0.638102 33.4185 -0.754821 29.9023 2.0899 24.4977)
//     path.cubicTo(
//       scale(-0.638102, 33.4185).dx, scale(-0.638102, 33.4185).dy,
//       scale(-0.754821, 29.9023).dx, scale(-0.754821, 29.9023).dy,
//       scale(2.0899, 24.4977).dx, scale(2.0899, 24.4977).dy,
//     );

//     // 4. Cubic Bézier Curve (C 5.29539 18.4078 15.4823 13.5773 18.2868 12.4983)
//     path.cubicTo(
//       scale(5.29539, 18.4078).dx, scale(5.29539, 18.4078).dy,
//       scale(15.4823, 13.5773).dx, scale(15.4823, 13.5773).dy,
//       scale(18.2868, 12.4983).dx, scale(18.2868, 12.4983).dy,
//     );

//     // 5. Cubic Bézier Curve (C 21.0914 11.4192 32.8914 6.4593 47.4017 3.91604)
//     path.cubicTo(
//       scale(21.0914, 11.4192).dx, scale(21.0914, 11.4192).dy,
//       scale(32.8914, 6.4593).dx, scale(32.8914, 6.4593).dy,
//       scale(47.4017, 3.91604).dx, scale(47.4017, 3.91604).dy,
//     );

//     // 6. Cubic Bézier Curve (C 46.2451 4.33206 60.6493 -0.000282001 86.0844 0.000595705)
//     path.cubicTo(
//       scale(46.2451, 4.33206).dx, scale(46.2451, 4.33206).dy,
//       scale(60.6493, -0.000282001).dx, scale(60.6493, -0.000282001).dy,
//       scale(86.0844, 0.000595705).dx, scale(86.0844, 0.000595705).dy,
//     );

//     // 7. Cubic Bézier Curve (C 111.519 0.00145815 126.754 2.95017 126.754 2.95017)
//     path.cubicTo(
//       scale(111.519, 0.00145815).dx, scale(111.519, 0.00145815).dy,
//       scale(126.754, 2.95017).dx, scale(126.754, 2.95017).dy,
//       scale(126.754, 2.95017).dx, scale(126.754, 2.95017).dy,
//     );

//     // 8. Cubic Bézier Curve (C 126.754 2.95017 146.494 5.50354 163.207 14.4514)
//     path.cubicTo(
//       scale(126.754, 2.95017).dx, scale(126.754, 2.95017).dy,
//       scale(146.494, 5.50354).dx, scale(146.494, 5.50354).dy,
//       scale(163.207, 14.4514).dx, scale(163.207, 14.4514).dy,
//     );

//     // 9. LineTo (L 168.927 18.0035)
//     path.lineTo(scale(168.927, 18.0035).dx, scale(168.927, 18.0035).dy);

//     // 10. LineTo (L 172.432 21.0031)
//     path.lineTo(scale(172.432, 21.0031).dx, scale(172.432, 21.0031).dy);

//     // 11. LineTo (L 174.535 23.5032)
//     path.lineTo(scale(174.535, 23.5032).dx, scale(174.535, 23.5032).dy);

//     // 12. LineTo (L 175.936 25.5063)
//     path.lineTo(scale(175.936, 25.5063).dx, scale(175.936, 25.5063).dy);

//     // 13. Cubic Bézier Curve (C 175.936 25.5063 177.091 29.416 177.09 30.9168)
//     path.cubicTo(
//       scale(175.936, 25.5063).dx, scale(175.936, 25.5063).dy,
//       scale(177.091, 29.416).dx, scale(177.091, 29.416).dy,
//       scale(177.09, 30.9168).dx, scale(177.09, 30.9168).dy,
//     );

//     // 14. Cubic Bézier Curve (C 177.09 32.4175 177.144 33.7885 176.64 35.5032)
//     path.cubicTo(
//       scale(177.09, 32.4175).dx, scale(177.09, 32.4175).dy,
//       scale(177.144, 33.7885).dx, scale(177.144, 33.7885).dy,
//       scale(176.64, 35.5032).dx, scale(176.64, 35.5032).dy,
//     );

//     // 15. Cubic Bézier Curve (C 176.135 37.2179 172.907 41.416 172.907 41.416)
//     path.cubicTo(
//       scale(176.135, 37.2179).dx, scale(176.135, 37.2179).dy,
//       scale(172.907, 41.416).dx, scale(172.907, 41.416).dy,
//       scale(172.907, 41.416).dx, scale(172.907, 41.416).dy,
//     );

//     // 16. LineTo (L 86.0947 154.421)
//     path.lineTo(scale(86.0947, 154.421).dx, scale(86.0947, 154.421).dy);

//     // 17. Close path (Z)
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

class CustomPolygonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // The SVG viewBox is 178x155. The coordinates need to be scaled
    // relative to the current size.
    final double scaleX = size.width / 178.0;
    final double scaleY = size.height / 155.0;

    // Helper function to scale coordinates
    Offset scale(double x, double y) {
      return Offset(x * scaleX, y * scaleY);
    }

    final path = Path();

    // 1. Move to starting point (M 86.0947 154.421)
    path.moveTo(scale(86.0947, 154.421).dx, scale(86.0947, 154.421).dy);

    // 2. Cubic Bézier Curve (C 86.0947 154.421 4.81987 45.1428 2.09089 39.2807)
    path.cubicTo(
      scale(86.0947, 154.421).dx, scale(86.0947, 154.421).dy,
      scale(4.81987, 45.1428).dx, scale(4.81987, 45.1428).dy,
      scale(2.09089, 39.2807).dx, scale(2.09089, 39.2807).dy,
    );

    // 3. Cubic Bézier Curve (C -0.638102 33.4185 -0.754821 29.9023 2.0899 24.4977)
    path.cubicTo(
      scale(-0.638102, 33.4185).dx, scale(-0.638102, 33.4185).dy,
      scale(-0.754821, 29.9023).dx, scale(-0.754821, 29.9023).dy,
      scale(2.0899, 24.4977).dx, scale(2.0899, 24.4977).dy,
    );

    // 4. Cubic Bézier Curve (C 5.29539 18.4078 15.4823 13.5773 18.2868 12.4983)
    path.cubicTo(
      scale(5.29539, 18.4078).dx, scale(5.29539, 18.4078).dy,
      scale(15.4823, 13.5773).dx, scale(15.4823, 13.5773).dy,
      scale(18.2868, 12.4983).dx, scale(18.2868, 12.4983).dy,
    );

    // 5. Cubic Bézier Curve (C 21.0914 11.4192 32.8914 6.4593 47.4017 3.91604)
    path.cubicTo(
      scale(21.0914, 11.4192).dx, scale(21.0914, 11.4192).dy,
      scale(32.8914, 6.4593).dx, scale(32.8914, 6.4593).dy,
      scale(47.4017, 3.91604).dx, scale(47.4017, 3.91604).dy,
    );

    // 6. Cubic Bézier Curve (C 46.2451 4.33206 60.6493 -0.000282001 86.0844 0.000595705)
    path.cubicTo(
      scale(46.2451, 4.33206).dx, scale(46.2451, 4.33206).dy,
      scale(60.6493, -0.000282001).dx, scale(60.6493, -0.000282001).dy,
      scale(86.0844, 0.000595705).dx, scale(86.0844, 0.000595705).dy,
    );

    // 7. Cubic Bézier Curve (C 111.519 0.00145815 126.754 2.95017 126.754 2.95017)
    path.cubicTo(
      scale(111.519, 0.00145815).dx, scale(111.519, 0.00145815).dy,
      scale(126.754, 2.95017).dx, scale(126.754, 2.95017).dy,
      scale(126.754, 2.95017).dx, scale(126.754, 2.95017).dy,
    );

    // 8. Cubic Bézier Curve (C 126.754 2.95017 146.494 5.50354 163.207 14.4514)
    path.cubicTo(
      scale(126.754, 2.95017).dx, scale(126.754, 2.95017).dy,
      scale(146.494, 5.50354).dx, scale(146.494, 5.50354).dy,
      scale(163.207, 14.4514).dx, scale(163.207, 14.4514).dy,
    );

    // 9. LineTo (L 168.927 18.0035)
    path.lineTo(scale(168.927, 18.0035).dx, scale(168.927, 18.0035).dy);

    // 10. LineTo (L 172.432 21.0031)
    path.lineTo(scale(172.432, 21.0031).dx, scale(172.432, 21.0031).dy);

    // 11. LineTo (L 174.535 23.5032)
    path.lineTo(scale(174.535, 23.5032).dx, scale(174.535, 23.5032).dy);

    // 12. LineTo (L 175.936 25.5063)
    path.lineTo(scale(175.936, 25.5063).dx, scale(175.936, 25.5063).dy);

    // 13. Cubic Bézier Curve (C 175.936 25.5063 177.091 29.416 177.09 30.9168)
    path.cubicTo(
      scale(175.936, 25.5063).dx, scale(175.936, 25.5063).dy,
      scale(177.091, 29.416).dx, scale(177.091, 29.416).dy,
      scale(177.09, 30.9168).dx, scale(177.09, 30.9168).dy,
    );

    // 14. Cubic Bézier Curve (C 177.09 32.4175 177.144 33.7885 176.64 35.5032)
    path.cubicTo(
      scale(177.09, 32.4175).dx, scale(177.09, 32.4175).dy,
      scale(177.144, 33.7885).dx, scale(177.144, 33.7885).dy,
      scale(176.64, 35.5032).dx, scale(176.64, 35.5032).dy,
    );

    // 15. Cubic Bézier Curve (C 176.135 37.2179 172.907 41.416 172.907 41.416)
    path.cubicTo(
      scale(176.135, 37.2179).dx, scale(176.135, 37.2179).dy,
      scale(172.907, 41.416).dx, scale(172.907, 41.416).dy,
      scale(172.907, 41.416).dx, scale(172.907, 41.416).dy,
    );

    // 16. LineTo (L 86.0947 154.421)
    path.lineTo(scale(86.0947, 154.421).dx, scale(86.0947, 154.421).dy);

    // 17. Close path (Z)
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}