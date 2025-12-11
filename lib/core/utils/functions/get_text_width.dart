import 'package:flutter/material.dart';

double getTextWidth({
  required String text,
  required TextStyle style,
  required BuildContext context,
  double? maxWidth, // Optional: Maximum width constraint
}) {
  final TextPainter textPainter =
      TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr, // Use RTL if needed for your app
        textScaler: MediaQuery.textScalerOf(context), // Respect text scaling
      )..layout(
        maxWidth: maxWidth ?? double.infinity,
      ); // Apply maxWidth if provided

  return textPainter.size.width;
}
