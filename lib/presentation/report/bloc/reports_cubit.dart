import 'package:bloc/bloc.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/data/api/profile_api.dart';
import 'package:hr_plus/data/model/report_model.dart';
import 'package:meta/meta.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ProfileApi _api = sl<ProfileApi>();

  ReportsCubit() : super(ReportsState());

  Future<void> getReports({String? startDate, String? endDate}) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await response(
      request: _api.getReports(
        createdAtStart: startDate,
        createdAtEnd: endDate,
      ),
    );

    result.fold(
      (l) => emit(state.copyWith(status: BlocStatus.error)),
      (r) => emit(state.copyWith(status: BlocStatus.success, reports: r)),
    );
  }
}
