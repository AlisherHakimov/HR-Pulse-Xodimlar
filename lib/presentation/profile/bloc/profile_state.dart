part of 'profile_cubit.dart';

class ProfileState {
  final UserModel? user;
  final BlocStatus status;

  final List<String> notifications;

  ProfileState({
    this.user,
    this.status = BlocStatus.initial,
    this.notifications = const [],
  });

  ProfileState copyWith({
    UserModel? user,
    BlocStatus? status,
    List<String>? notifications,
    List<AttendanceModel>? attendances,
    List<ActionModel>? dailyActions,
  }) {
    return ProfileState(
      user: user ?? this.user,
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
    );
  }
}
