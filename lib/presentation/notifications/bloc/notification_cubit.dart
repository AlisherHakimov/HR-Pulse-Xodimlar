
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_plus/core/utils/enums.dart';
import 'package:hr_plus/data/api/profile_api.dart';
import 'package:hr_plus/data/di/di_container.dart';
import 'package:hr_plus/data/dio/api_helper.dart';
import 'package:hr_plus/data/model/notification_model.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final _api = sl<ProfileApi>();

  NotificationCubit() : super(NotificationState());

  Future<void> getNotifications({int? page}) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await response(request: _api.getNotifications(page: page));
    result.fold(
      (l) {
        emit(state.copyWith(status: BlocStatus.error));
      },
      (r) {
        emit(
          state.copyWith(
            notifications: page == 1
                ? r.results
                : [...state.notifications, ...?r.results],
            status: BlocStatus.success,
            page: r.currentPage,
            unreadCount: r.unreadCount,
          ),
        );
      },
    );
  }

  Future<void> readNotification(String id) async {
    final result = await response(request: _api.readNotification(id));
    result.fold(
      (l) {
        emit(state.copyWith(status: BlocStatus.error));
      },
      (r) {
        getNotifications(page: 1);
        emit(state.copyWith(status: BlocStatus.success));
      },
    );
  }

  Future<void> readAllNotifications({
    required Function(String) onError,
    required Function() onSuccess,
  }) async {
    emit(state.copyWith(readStatus: BlocStatus.loading));
    final result = await response(request: _api.readAllNotifications());

    result.fold(
      (l) {
        onError.call(l.message);
        emit(state.copyWith(readStatus: BlocStatus.error));
      },
      (r) {
        getNotifications(page: 1);
        emit(state.copyWith(readStatus: BlocStatus.success));
        onSuccess.call();
      },
    );
  }
}
