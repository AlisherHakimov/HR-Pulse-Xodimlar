part of 'notification_cubit.dart';

class NotificationState {
  final BlocStatus status;
  final BlocStatus readStatus;
  final List<NotificationModel> notifications;
  final int page;
  final int unreadCount;

  NotificationState({
    this.status = BlocStatus.initial,
    this.readStatus = BlocStatus.initial,
    this.notifications = const [],
    this.page = 1,
    this.unreadCount = 0,
  });

  NotificationState copyWith({
    BlocStatus? status,
    BlocStatus? readStatus,
    List<NotificationModel>? notifications,
    int? page,
    int? unreadCount,
  }) {
    return NotificationState(
      status: status ?? this.status,
      readStatus: readStatus ?? this.readStatus,
      notifications: notifications ?? this.notifications,
      page: page ?? this.page,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
