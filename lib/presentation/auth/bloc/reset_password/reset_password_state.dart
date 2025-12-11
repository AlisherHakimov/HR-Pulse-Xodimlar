part of 'reset_password_cubit.dart';

class ResetPasswordState {
  final BlocStatus status;

  ResetPasswordState({this.status = BlocStatus.initial});

  ResetPasswordState copyWith({BlocStatus? status}) =>
      ResetPasswordState(status: status ?? this.status);
}
