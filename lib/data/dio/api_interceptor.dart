import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/main.dart';
import 'package:hr_plus/presentation/auth/pages/login_page.dart';

import 'check_token_expires.dart';

Map<String, String> _headers = {
  HttpHeaders.acceptHeader: 'application/json',
  // Only set content-type when sending JSON bodies; Retrofit may override for forms
};

bool isLoggedOut = false;

class CommonRequestInterceptor extends QueuedInterceptor {
  CommonRequestInterceptor();

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll(_headers);
    log('${options.method} >>> ${options.uri}');
    log('Query parameters: ${options.queryParameters}');
    // Avoid printing sensitive headers in logs
    final redactedHeaders = Map.of(options.headers);
    if (redactedHeaders.containsKey(HttpHeaders.authorizationHeader)) {
      redactedHeaders[HttpHeaders.authorizationHeader] = 'Bearer <redacted>';
    }
    log('Header parameters: $redactedHeaders');
    log('Request data: ${options.data}', sequenceNumber: 20);
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    log('${response.requestOptions.method} <<< ${response.requestOptions.uri}');
    log('Response data: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    log('${err.requestOptions.method} <<< ${err.requestOptions.uri}');
    log('Error data: ${err.response?.data}');
    // handler.next(err);
    log('Response data: ');
    if (err.response?.statusCode == HttpStatus.forbidden && !isLoggedOut) {
      localeStorage.clear();
      navigatorKey.currentState?.context.pushAndRemoveAll(LoginPage());
      isLoggedOut = true;
      return super.onError(err, handler);
    }
  }
}

class AuthorizedRequestInterceptor extends CommonRequestInterceptor {
  AuthorizedRequestInterceptor(Dio dio);

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (!isTokenExpired) {
        options.headers[HttpHeaders.authorizationHeader] =
            "Bearer ${localeStorage.accessToken}";
      }

      return super.onRequest(options, handler);
    } on DioException catch (e) {
      handler.reject(e, true);
    } on Object catch (e) {
      log('$e');
    }
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    log('Response data:${err.response?.statusCode} ');

    if (err.response?.statusCode == HttpStatus.forbidden && !isLoggedOut) {
      localeStorage.clear();
      navigatorKey.currentState?.context.pushAndRemoveAll(LoginPage());
      isLoggedOut = true;
      return super.onError(err, handler);
    }

    if (err.response?.statusCode == HttpStatus.unauthorized) {
      log('Response data:${err.response?.statusCode} ');
      return super.onError(err, handler);
    } else {
      return super.onError(err, handler);
    }
  }
}
