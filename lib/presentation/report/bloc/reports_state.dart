part of 'reports_cubit.dart';

class ReportsState {
  final BlocStatus status;
  final List<ReportModel> reports;

  ReportsState({this.status = BlocStatus.initial, this.reports = const []});

  ReportsState copyWith({BlocStatus? status, List<ReportModel>? reports}) {
    return ReportsState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
    );
  }
}

