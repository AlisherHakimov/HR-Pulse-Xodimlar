import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../core.dart';

@module
abstract class InternetModule {
  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker.instance;
}

Future<bool> hasConnection() {
  final InternetConnectionChecker connection = sl<InternetConnectionChecker>();
  return connection.hasConnection;
}
