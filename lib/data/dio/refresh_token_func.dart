import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hr_plus/data/di/di_container.dart';
import 'package:hr_plus/main.dart';


Future<void> refreshTokenFunction() async {
  log('accessToken===>${localeStorage.refreshToken}');
  try {
    final response = await sl<Dio>().post(
      '//auth/refresh',
      data: {'refresh': localeStorage.refreshToken},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'charset': 'utf-8',
          'Accept': 'application/json',
        },
        responseType: ResponseType.json,
      ),
    );

    final responseJson = response.data;
    log('responseJson===>$responseJson');
    localeStorage.saveTokens(
      accessToken: responseJson['access'],
      refreshToken: responseJson['refresh'],
    );
    log("response===>${response.statusCode} ${response.data}");
  } on DioException catch (e) {
    log('Error===>: $e');
  }
}
