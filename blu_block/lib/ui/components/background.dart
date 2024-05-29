import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paintOne = Paint()..color = Colors.orange.withOpacity(0.6);
    Paint paintTwo = Paint()..color = Colors.blue.withOpacity(0.2);

    // Calculate the control point for the curve
    Offset controlPoint = Offset(size.width / .9, size.height / 1.1);
    Offset controlPoint2 = Offset(size.width * .8 / 1.5, size.height / 1.1);

    // Draw the orange area
    Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        0,
        size.height,
      )
      ..close();

    Path path2 = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.width)
      ..quadraticBezierTo(
        controlPoint2.dx,
        controlPoint2.dy,
        size.width,
        size.height,
      )
      ..close();

    canvas.drawPath(path, paintOne);
    canvas.drawPath(path2, paintTwo);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}