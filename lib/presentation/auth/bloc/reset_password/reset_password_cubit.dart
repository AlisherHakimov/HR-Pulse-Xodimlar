import 'package:hr_plus/data/api/auth_api.dart';
import 'package:hr_plus/main.dart';

import '../../../../core/core.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final _authApi = sl<AuthApi>();

  ResetPasswordCubit() : super(ResetPasswordState());

  Future<void> resetPassword({
    required String phoneNumber,
    Function(String)? onError,
    Function(String sessionId)? onSuccess,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final result = await response(
      request: _authApi.resetPassword(phoneNumber: phoneNumber),
    );
    result.fold(
      (l) {
        onError?.call(l.message);
        emit(state.copyWith(status: BlocStatus.error));
      },
      (r) {
        onSuccess?.call(r.session ?? '');
        emit(state.copyWith(status: BlocStatus.success));
      },
    );
  }

  Future<void> resetPasswordResendOtp({
    required String sessionId,

    required String phoneNumber,
    Function(String)? onError,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final result = await response(
      request: _authApi.resetPasswordResendOtp(
        sessionId: sessionId,
        phoneNumber: phoneNumber,
      ),
    );
    result.fold(
      (l) {
        onError?.call(l.message);
        emit(state.copyWith(status: BlocStatus.error));
      },
      (r) {
        emit(state.copyWith(status: BlocStatus.success));
      },
    );
  }

  Future<void> resetPasswordVerifyUser({
    required String sessionId,

    required int otp,
    Function(String)? onError,
    Function()? onSuccess,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final result = await response(
      request: _authApi.resetPasswordVerifyUser(sessionId: sessionId, otp: otp),
    );
    result.fold(
      (l) {
        onError?.call(l.message);
        emit(state.copyWith(status: BlocStatus.error));
      },
      (r) {
        onSuccess?.call();
        localeStorage.saveTokens(
          accessToken: r.accessToken ?? '',
          refreshToken: r.refreshToken,
        );
        emit(state.copyWith(status: BlocStatus.success));
      },
    );
  }

  Future<void> changePassword({
    required String sessionId,
    required String newPassword,
    Function()? onSuccess,
    Function(String)? onError,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final result = await response(
      request: _authApi.changePassword(
        sessionId: sessionId,
        newPassword: newPassword,
      ),
    );
    result.fold(
      (l) {
        onError?.call(l.message);
        emit(state.copyWith(status: BlocStatus.error));
      },
      (r) {
        localeStorage.setLoggedIn(true);
        onSuccess?.call();
        emit(state.copyWith(status: BlocStatus.success));
      },
    );
  }
}
