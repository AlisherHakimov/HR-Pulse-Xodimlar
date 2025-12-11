import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  Locale get locale => Localizations.localeOf(this);
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double get bottom => MediaQuery.of(this).viewInsets.bottom;
  double get top => MediaQuery.of(this).viewInsets.top;

  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomNavigationBarHeight => MediaQuery.of(this).padding.bottom;

  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;

  double get keyboardHeightWithPadding =>
      MediaQuery.of(this).viewInsets.bottom +
      MediaQuery.of(this).padding.bottom;

}
