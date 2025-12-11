import 'package:hr_plus/data/api/auth_api.dart';
import 'package:hr_plus/main.dart';

import '../../../../core/core.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final _api = sl<AuthApi>();

  LoginCubit() : super(LoginState());

  Future<void> loginUser({
    required String phoneNumber,
    required String password,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final result = await response(
      request: _api.loginUser(phoneNumber: phoneNumber, password: password),
    );
    result.fold(
      (l) {
        emit(state.copyWith(status: BlocStatus.error));
        onError(l.message);
      },
      (r) {
        emit(state.copyWith(status: BlocStatus.success));
        localeStorage.setLoggedIn(true);
        localeStorage.saveTokens(
          accessToken: r.accessToken ?? '',
          refreshToken: r.refreshToken,
        );
        onSuccess();
      },
    );
  }
}
