import 'package:hr_plus/data/api/profile_api.dart';
import 'package:hr_plus/data/model/Attendance_model.dart';
import 'package:hr_plus/data/model/action_model.dart';
import 'package:hr_plus/data/model/user_model.dart';

import '../../../core/core.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final _api = sl<ProfileApi>();

  ProfileCubit() : super(ProfileState());

  Future<void> getMe() async {
    final result = await response(request: _api.getMe());

    result.fold(
      (l) {
        emit(state.copyWith(status: BlocStatus.error));
      },
      (r) {
        emit(state.copyWith(user: r, status: BlocStatus.success));
      },
    );
  }
}
