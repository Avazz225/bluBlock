import 'dart:math';
import 'package:flutter/material.dart';

class CircularProgressIndicatorWidget extends StatefulWidget {
  final double progress;
  final double failedProgress;
  final int valueX;
  final int valueY;
  final int valueZ;
  final bool blockingActive;

  const CircularProgressIndicatorWidget({
    super.key,
    required this.progress,
    required this.failedProgress,
    required this.valueX,
    required this.valueY,
    required this.valueZ,
    required this.blockingActive,
  });

  @override
  _CircularProgressIndicatorWidgetState createState() => _CircularProgressIndicatorWidgetState();
}

class _CircularProgressIndicatorWidgetState extends State<CircularProgressIndicatorWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(200, 200),
              painter: CircularProgressPainter(
                progress: widget.progress,
                failedProgress: widget.failedProgress,
                blockingActive: widget.blockingActive,
                rotationAngle: _animation.value,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.valueX} / ${widget.valueY}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Gescheitert: ${widget.valueZ}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double failedProgress;
  final bool blockingActive;
  final double rotationAngle;

  CircularProgressPainter({
    required this.progress,
    required this.failedProgress,
    required this.blockingActive,
    required this.rotationAngle,
  });

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
    double totalSweepAngle = 2 * pi * progress;
    double failedSweepAngle = 2 * pi * (failedProgress.isNaN ? 0 : failedProgress);
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

    if (blockingActive) {
      Paint rotatingSegmentPaint = Paint()
        ..color = Colors.blue.shade800
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      double segmentAngle = pi / 5; // 20% of the circle
      double startAngle1 = rotationAngle;
      double startAngle2 = rotationAngle + pi;

      double outerRadius = radius + 10; // Small gap and then segment radius
      Rect outerRect = Rect.fromCircle(center: center, radius: outerRadius);

      canvas.drawArc(
        outerRect,
        startAngle1,
        segmentAngle,
        false,
        rotatingSegmentPaint,
      );

      canvas.drawArc(
        outerRect,
        startAngle2,
        segmentAngle,
        false,
        rotatingSegmentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.failedProgress != failedProgress ||
        oldDelegate.blockingActive != blockingActive ||
        oldDelegate.rotationAngle != rotationAngle;
  }
}
