import 'package:flutter/material.dart';

class DiagonalLineWidget extends StatelessWidget {
  final Widget child;
  final Color lineColor;
  final double lineWidth;

  const DiagonalLineWidget({
    super.key,
    required this.child,
    this.lineColor = Colors.red,
    this.lineWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(
            fit: StackFit.expand, // Ensures the Stack takes the full size
            children: [
              child,
              CustomPaint(
                painter: DiagonalLinePainter(
                  color: lineColor,
                  width: lineWidth,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DiagonalLinePainter extends CustomPainter {
  final Color color;
  final double width;

  DiagonalLinePainter({required this.color, required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return; // Avoid drawing if size is zero
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height), // Bottom-left
      Offset(size.width, 0), // Top-right
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
