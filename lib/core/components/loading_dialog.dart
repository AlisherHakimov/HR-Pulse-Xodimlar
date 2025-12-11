import 'package:flutter/material.dart';
import 'package:hr_plus/main.dart';

void showLoadingDialog() {
  showDialog(
    context: navigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );
}

void hideLoadingDialog() {
  navigatorKey.currentState?.pop();
}
