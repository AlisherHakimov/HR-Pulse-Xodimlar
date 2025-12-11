part of 'permission_cubit.dart';

class PermissionState {
  final BlocStatus status;
  final BlocStatus createStatus;
  final List<PermissionModel> permissions;
  final StatusCounts? statusCounts;
  final List<ReasonModel> reasons;
  final PermissionStatus permissionStatus;
  final int page;

  PermissionState({
    this.status = BlocStatus.initial,
    this.createStatus = BlocStatus.initial,
    this.permissions = const [],
    this.reasons = const [],
    this.statusCounts ,
    this.permissionStatus = PermissionStatus.ALL,
    this.page = 1,
  });

  PermissionState copyWith({
    BlocStatus? status,
    BlocStatus? createStatus,
    List<PermissionModel>? permissions,
    List<ReasonModel>? reasons,
    StatusCounts? statusCounts,
    PermissionStatus? permissionStatus,
    int? page,
  }) {
    return PermissionState(
      status: status ?? this.status,
      createStatus: createStatus ?? this.createStatus,
      permissions: permissions ?? this.permissions,
      reasons: reasons ?? this.reasons,
      page: page ?? this.page,
      statusCounts: statusCounts ?? this.statusCounts,
      permissionStatus: permissionStatus ?? this.permissionStatus,
    );
  }
}
