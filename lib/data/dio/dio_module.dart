import 'package:dio/dio.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/main.dart';
import 'package:hr_plus/presentation/connection/connection_page.dart';
import 'package:injectable/injectable.dart';

import 'api_interceptor.dart';
import 'retry_interseptor.dart';

@module
abstract class DioModule {
  @Named("Host")
  String get host => "api.tictac.sector-soft.ru/api";

  @Named("TestHost")
  String get testHost => 'api.tictac.sector-soft.ru/api';

  @Named("Environment")
  bool get isTest => const bool.hasEnvironment("isTest");

  @singleton
  Future<Dio> getAuthorizedDioClient({
    @Named("Environment") required bool isTest,
    @Named("Host") required String host,
    @Named("TestHost") required String testHost,
  }) async {
    String baseUrl = 'https://${isTest ? testHost : host}';
    final authorizedDioClient = _createDioClient(baseUrl);
    authorizedDioClient.interceptors.addAll([
      alice.getDioInterceptor(),
      AuthorizedRequestInterceptor(authorizedDioClient),
      RetryInterceptor(
        dio: authorizedDioClient,
        logPrint: (String message) {},
        retries: 3,
        accessTokenGetter: () => localeStorage.accessToken,
        toNoInternetPageNavigator: () =>
            navigatorKey.currentContext!.push(const ConnectionPage()),
      ),
    ]);
    return authorizedDioClient;
  }

  @Named("UnauthorizedClient")
  @singleton
  Future<Dio> getUnauthorizedDioClient({
    @Named("Environment") required bool isTest,
    @Named("Host") required String host,
    @Named("TestHost") required String testHost,
  }) async {
    String baseUrl = 'https://${isTest ? testHost : host}/';
    final unauthorizedDioClient = _createDioClient(baseUrl);
    unauthorizedDioClient.interceptors.addAll([
      alice.getDioInterceptor(),
      CommonRequestInterceptor(),
      RetryInterceptor(
        dio: unauthorizedDioClient,
        logPrint: (String message) {},
        retries: 3,
        accessTokenGetter: () => localeStorage.accessToken,
        toNoInternetPageNavigator: () =>
            navigatorKey.currentContext!.push(const ConnectionPage()),
      ),
    ]);
    return unauthorizedDioClient;
  }

  Dio _createDioClient(String baseUrl) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      // connectTimeout: _requestTimeoutInMilliseconds,
      // receiveTimeout: _requestTimeoutInMilliseconds,
    );
    return Dio(options);
  }
}
