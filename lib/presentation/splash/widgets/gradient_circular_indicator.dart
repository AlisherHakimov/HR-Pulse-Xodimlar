import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class GradientCircularProgressIndicator extends StatelessWidget {
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;
  final Color backgroundColor;
  final double progress;

  const GradientCircularProgressIndicator({
    super.key,
    required this.radius,
    required this.gradientColors,
    this.strokeWidth = 10.0,
    this.backgroundColor = Colors.grey,
    this.progress = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(radius),
      painter: GradientCircularProgressPainter(
        radius: radius,
        gradientColors: gradientColors,
        strokeWidth: strokeWidth,
        backgroundColor: backgroundColor,
        progress: progress,
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;
  final Color backgroundColor;
  final double progress;

  GradientCircularProgressPainter({
    required this.radius,
    required this.gradientColors,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: size.width,
      height: size.height,
    );

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Draw gradient progress
    if (progress > 0) {
      final gradientPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      // Create sweep gradient
      final gradient = SweepGradient(
        startAngle: -math.pi / 2, // Start from top
        colors: gradientColors.length >= 2
            ? gradientColors
            : [gradientColors.first, gradientColors.first],
      );

      gradientPaint.shader = gradient.createShader(rect);

      // Draw the main arc
      final startAngle = -math.pi / 2; // Start from top (12 o'clock)
      final sweepAngle = 2 * math.pi * progress; // Sweep based on progress

      canvas.drawArc(
        Rect.fromCenter(
          center: center,
          width: (radius - strokeWidth / 2) * 2,
          height: (radius - strokeWidth / 2) * 2,
        ),
        startAngle,
        sweepAngle,
        false,
        gradientPaint,
      );

      // Draw rounded caps manually
      if (progress > 0 && progress < 1.0) {
        // Start cap
        final startCapPaint = Paint()
          ..color = gradientColors.first
          ..style = PaintingStyle.fill;

        final startCapAngle = startAngle;
        final startCapCenter = Offset(
          center.dx + (radius - strokeWidth / 2) * math.cos(startCapAngle),
          center.dy + (radius - strokeWidth / 2) * math.sin(startCapAngle),
        );

        canvas.drawCircle(startCapCenter, strokeWidth / 2, startCapPaint);

        // End cap
        final endCapPaint = Paint()
          ..color = gradientColors.last
          ..style = PaintingStyle.fill;

        final endCapAngle = startAngle + sweepAngle;
        final endCapCenter = Offset(
          center.dx + (radius - strokeWidth / 2) * math.cos(endCapAngle),
          center.dy + (radius - strokeWidth / 2) * math.sin(endCapAngle),
        );

        canvas.drawCircle(endCapCenter, strokeWidth / 2, endCapPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is GradientCircularProgressPainter &&
        (oldDelegate.progress != progress ||
            oldDelegate.gradientColors != gradientColors ||
            oldDelegate.backgroundColor != backgroundColor);
  }
}
