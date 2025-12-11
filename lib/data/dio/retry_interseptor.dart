import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/data/dio/refresh_token_func.dart';
import 'package:hr_plus/main.dart';
import 'package:hr_plus/presentation/auth/pages/login_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

typedef RetryEvaluator =
    FutureOr<bool> Function(DioException error, int attempt);
typedef RefreshTokenFunction = Future<void> Function();
typedef AccessTokenGetter = String Function();
typedef ForbiddenFunction = Future<void> Function();
typedef ToNoInternetPageNavigator = Future<void> Function();

/// An interceptor that will try to send failed request again
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    required this.logPrint,
    this.retries = 1,
    this.accessTokenGetter,
    this.forbiddenFunction,
    required this.toNoInternetPageNavigator,
    this.retryDelays = const [Duration(seconds: 1)],
  });

  /// The original dio
  final Dio dio;

  ///refresh token functi   ons get api client

  ///refresh token functions get api client
  final ForbiddenFunction? forbiddenFunction;

  /// Access token getter from storage
  final AccessTokenGetter? accessTokenGetter;

  /// ToNoInternetPage navigate
  final ToNoInternetPageNavigator toNoInternetPageNavigator;

  /// For logging purpose
  final void Function(String message) logPrint;

  /// The number of retry in case of an error
  final int retries;

  /// The delays between attempts.
  /// Empty [retryDelays] means no delay.
  ///
  /// If [retries] count more than [retryDelays] count,
  /// the last value of [retryDelays] will be used.
  final List<Duration> retryDelays;

  /// Evaluating if a retry is necessary.regarding the error.
  ///
  /// It can be a good candidate for additional operations too, like
  /// updating authentication token in case of a unauthorized error (be careful
  /// with concurrency though).
  ///
  /// Defaults to [defaultRetryEvaluator].
  // final RetryEvaluator _retryEvaluator;

  /// Returns true only if the response hasn't been cancelled or got
  /// a bas status code.
  Future<bool> defaultRetryEvaluator(DioException error, int attempt) async {
    bool shouldRetry = false;
    bool accessTokenHasExpired = false;

    bool refreshTokenHasExpired = false;
    if (localeStorage.isLoggedIn) {
      if (localeStorage.accessToken.isNotEmpty) {
        accessTokenHasExpired = JwtDecoder.isExpired(localeStorage.accessToken);
        refreshTokenHasExpired = JwtDecoder.isExpired(
          localeStorage.refreshToken,
        );
      }

      if (accessTokenHasExpired) {
        if (refreshTokenHasExpired) {
          // localeStorage.clearTokens();
          // localeStorage.setLoggedIn(false);
          // DeviceIdManager.getDeviceId();
          navigatorKey!.currentState!.pushAndRemoveAll(const LoginPage());
          shouldRetry = false;
        } else {
          logPrint('refresh ++++++++++++++++++>>>>>>>>>>>>>>>>>>>>');
          await refreshTokenFunction();
          shouldRetry = true;
        }
      } else if (error.type == DioExceptionType.unknown) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            shouldRetry = true;
          } else {
            shouldRetry = true;
          }
        } on SocketException catch (_) {
          await toNoInternetPageNavigator();
          shouldRetry = true;
        }
      } else if (error.type == DioExceptionType.connectionError) {
        await toNoInternetPageNavigator();
        shouldRetry = true;
      } else {
        shouldRetry = false;
      }
    }
    return shouldRetry;
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.disableRetry) return super.onError(err, handler);
    final attempt = err.requestOptions._attempt + 1;
    final shouldRetry =
        attempt <= retries && await defaultRetryEvaluator(err, attempt);

    if (!shouldRetry) return super.onError(err, handler);

    err.requestOptions._attempt = attempt;
    final delay = _getDelay(attempt);
    logPrint.call(
      '[${err.requestOptions.uri}] An error occurred during request, '
      'trying again '
      '(attempt: $attempt/$retries, '
      'wait ${delay.inMilliseconds} ms, '
      'error: ${err.error})',
    );

    if (delay != Duration.zero) await Future<void>.delayed(delay);
    final header = <String, dynamic>{}..addAll(err.requestOptions.headers);
    if (accessTokenGetter != null) {
      header['Authorization'] = accessTokenGetter!();
    }
    err.requestOptions.headers = header;
    try {
      await dio
          .fetch<void>(err.requestOptions)
          .then((value) => handler.resolve(value));
    } on DioException catch (e, s) {
      logPrint('error: $e $s');
      super.onError(e, handler);
    } on Exception catch (e, s) {
      logPrint('error: $e $s');
    }
  }

  Duration _getDelay(int attempt) {
    if (retryDelays.isEmpty) return Duration.zero;
    return attempt - 1 < retryDelays.length
        ? retryDelays[attempt - 1]
        : retryDelays.last;
  }
}

extension RequestOptionsX on RequestOptions {
  static const _kAttemptKey = 'ro_attempt';
  static const _kDisableRetryKey = 'ro_disable_retry';

  int get _attempt => extra[_kAttemptKey] ?? 0;

  set _attempt(int value) => extra[_kAttemptKey] = value;

  bool get disableRetry => (extra[_kDisableRetryKey] as bool?) ?? false;

  set disableRetry(bool value) => extra[_kDisableRetryKey] = value;
}

const retryableStatuses = <int>{401, 502, 599, 522, 500};

bool isRetryable(int statusCode) => retryableStatuses.contains(statusCode);
