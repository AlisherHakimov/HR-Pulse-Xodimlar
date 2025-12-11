import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hr_plus/core/network/failure.dart';

Future<Either<Failure, T>> response<T>({required Future<T> request}) async {
  try {
    final response = await request;
    return Right(response);
  } on DioException catch (e) {
    return Left(ServerError.withDioError(error: e).failure);
  } catch (e) {
    log(e.toString());
    return Left(ServerError.withError(message: e.toString()).failure);
  }
}

final class ServerError implements Exception {
  ServerError.withDioError({required DioException error}) {
    _handleError(error);
  }

  ServerError.withError({required String message, int? code}) {
    _errorMessage = message;
    _errorCode = code;
  }

  int? _errorCode;
  String _errorMessage = '';

  int get errorCode => _errorCode ?? 0;

  String get message => _errorMessage;

  void _handleError(DioException error) {
    log(error.type.toString());

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        _errorMessage = 'Connection timeout';
      case DioExceptionType.sendTimeout:
        _errorMessage = 'Connection timeout';
      case DioExceptionType.receiveTimeout:
        _errorMessage = 'Connection timeout';
      case DioExceptionType.badResponse:
        {
          log(error.response!.data.runtimeType.toString());
          if (error.response?.data is Map<String, dynamic>) {
            Map<String, dynamic> data =
                error.response!.data as Map<String, dynamic>;
            _errorMessage =
                data['code'] ??
                data['error'] ??
                data.values.first.toString() ??
                'something_went_wrong';
          } else {
            _errorMessage = error.response!.data.toString();
          }
          break;
        }
      case DioExceptionType.cancel:
        _errorMessage = 'Canceled';
      case DioExceptionType.unknown:
        _errorMessage = 'Something went wrong';
      case DioExceptionType.badCertificate:
        _errorMessage = 'Bad certificate';
      case DioExceptionType.connectionError:
        _errorMessage = 'connection_error';
    }
    _errorCode = error.response?.statusCode ?? 500;
    if (_errorCode == 500) {
      _errorMessage = 'server_error';
      return;
    }
    if (_errorCode == 502) {
      _errorMessage = 'Server down';
      return;
    }
    return;
  }
}

extension ServerErrorExtension on ServerError {
  bool get isTokenExpired => errorCode == 401;

  ServerFailure get failure => ServerFailure(
    message.isEmpty ? 'Something went wrong' : message.tr(),
    statusCode: errorCode,
  );
}
