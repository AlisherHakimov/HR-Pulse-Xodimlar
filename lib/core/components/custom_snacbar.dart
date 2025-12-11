import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showSuccess(BuildContext context, String message) {
  Flushbar(
    message: message,
    duration: Duration(seconds: 3),
    margin: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(10),
    backgroundColor: Colors.green,
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: Duration(milliseconds: 500),
    icon: Icon(
      Icons.check_circle_outline,
      size: 28.0,
      color: Colors.white,
    ),
  ).show(context);
}

void showError(BuildContext context, String message) {
  Flushbar(
    message: message,
    duration: Duration(seconds: 3),
    margin: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(10),
    backgroundColor: Colors.red,
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: Duration(milliseconds: 500),
    icon: Icon(
      Icons.error_outline,
      size: 28.0,
      color: Colors.white,
    ),
  ).show(context);
}