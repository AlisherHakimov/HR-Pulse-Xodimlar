import 'package:flutter/material.dart';

class CircularSplashTextButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const CircularSplashTextButton(
      {super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: onPressed,
        splashColor: Colors.grey.shade400.withOpacity(0.3),
        // Custom splash color
        highlightShape: BoxShape.circle,
        containedInkWell: true,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Center(child: child),
        ),
      ),
    );
  }
}
