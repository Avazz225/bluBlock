import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgressIndicatorWidget extends StatelessWidget {
  final double progress;
  final double failedProgress;
  final int valueX;
  final int valueY;
  final int valueZ;

  const CircularProgressIndicatorWidget({
    super.key,
    required this.progress,
    required this.failedProgress,
    required this.valueX,
    required this.valueY,
    required this.valueZ,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(200, 200),
          painter: CircularProgressPainter(
            progress: progress,
            failedProgress: failedProgress,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$valueX / $valueY',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Gescheitert: $valueZ',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        )
      ],
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double failedProgress;

  CircularProgressPainter({required this.progress, required this.failedProgress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.green.withOpacity(0.25)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    Paint progressPaint = Paint()
      ..color = Colors.green.shade600
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint failedPaint = Paint()
      ..color = Colors.red.shade600
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double radius = min(size.width / 2, size.height / 2);
    Offset center = Offset(size.width / 2, size.height / 2);
    double totalSweepAngle  = 2 * pi * progress;
    double failedSweepAngle = 2 * pi * ((failedProgress.isNaN)? 0: failedProgress);
    Rect myRect = Rect.fromCircle(center: center, radius: radius);

    // Draw the background circle
    canvas.drawArc(
      myRect,
      0,
      2 * pi,
      false,
      backgroundPaint,
    );

    // Draw the failed progress arc
    canvas.drawArc(
      myRect,
      -pi / 2 + totalSweepAngle,
      failedSweepAngle,
      false,
      failedPaint,
    );

    // Draw the successful progress arc
    canvas.drawArc(
      myRect,
      -pi / 2,
      totalSweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.failedProgress != failedProgress;
  }
}