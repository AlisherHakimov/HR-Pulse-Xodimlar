part of 'home_cubit.dart';

class HomeState {
  final BlocStatus status;
  final BlocStatus getActionStatus;
  final List<AttendanceModel> attendances;
  final List<ActionModel> dailyActions;

  HomeState({
    this.status = BlocStatus.initial,
    this.getActionStatus = BlocStatus.initial,
    this.attendances = const [],
    this.dailyActions = const [],
  });

  HomeState copyWith({
    BlocStatus? status,
    BlocStatus? getActionStatus,
    List<AttendanceModel>? attendances,
    List<ActionModel>? dailyActions,
  }) {
    return HomeState(
      status: status ?? this.status,
      getActionStatus: getActionStatus ?? this.getActionStatus,
      attendances: attendances ?? this.attendances,
      dailyActions: dailyActions ?? this.dailyActions,
    );
  }
}
