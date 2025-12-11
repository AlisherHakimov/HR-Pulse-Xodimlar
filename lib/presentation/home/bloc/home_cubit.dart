import 'package:hr_plus/data/api/profile_api.dart';
import 'package:hr_plus/data/model/Attendance_model.dart';
import 'package:hr_plus/data/model/action_model.dart';

import '../../../core/core.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final _api = sl<ProfileApi>();

  HomeCubit() : super(HomeState());

  Future<void> getAttendance({DateTime? date}) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final result = await response(
      request: _api.getAttendance(year: date?.year, month: date?.month),
    );

    result.fold(
      (l) {
        emit(state.copyWith(status: BlocStatus.error));
      },
      (r) {
        emit(state.copyWith(attendances: r, status: BlocStatus.success));
      },
    );
  }

  Future<void> getDailyActions({required String id}) async {
    emit(state.copyWith(getActionStatus: BlocStatus.loading));
    final result = await response(request: _api.getDailyActions(id: id));

    result.fold(
      (l) {
        emit(
          state.copyWith(getActionStatus: BlocStatus.error, dailyActions: []),
        );
      },
      (r) {
        emit(
          state.copyWith(dailyActions: r, getActionStatus: BlocStatus.success),
        );
      },
    );
  }
}
