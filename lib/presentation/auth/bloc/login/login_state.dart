part of 'login_cubit.dart';

class LoginState {
  final BlocStatus status;

  LoginState({this.status = BlocStatus.initial});

  LoginState copyWith({BlocStatus? status}) {
    return LoginState(status: status ?? this.status);
  }
}
