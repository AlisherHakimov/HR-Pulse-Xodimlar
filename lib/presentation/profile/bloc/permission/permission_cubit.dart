import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hr_plus/core/utils/enums.dart';
import 'package:hr_plus/data/api/profile_api.dart';
import 'package:hr_plus/data/di/di_container.dart';
import 'package:hr_plus/data/dio/api_helper.dart';
import 'package:hr_plus/data/model/permission_model.dart';
import 'package:hr_plus/data/model/permissions_response.dart';
import 'package:hr_plus/data/model/reason_model.dart';
import 'package:hr_plus/data/model/request/permission_request.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  final _api = sl<ProfileApi>();

  PermissionCubit() : super(PermissionState());

  Future<void> getPermissions({PermissionStatus? status, int page = 1}) async {
    emit(
      state.copyWith(
        status: page == 1 ? BlocStatus.loading : null,
        permissionStatus: status,
      ),
    );
    final result = await response(
      request: _api.getPermissions(
        status: status == PermissionStatus.ALL ? null : status?.name,
        page: page,
      ),
    );

    result.fold(
      (l) {
        log(l.message, name: "error");
        emit(state.copyWith(status: BlocStatus.error));
      },
      (r) {
        emit(
          state.copyWith(
            permissions: page == 1
                ? r.results
                : [...state.permissions, ...?r.results],
            statusCounts: r.statusCounts,
            status: BlocStatus.success,
            page: page,
          ),
        );
      },
    );
  }

  Future<void> getPermissionById(
    String id, {
    Function(PermissionModel)? onSuccess,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final result = await response(request: _api.getPermissionById(id));
    result.fold(
      (l) {
        emit(state.copyWith(status: BlocStatus.error));
      },
      (r) {
        emit(state.copyWith(status: BlocStatus.success));
        onSuccess?.call(r);
      },
    );
  }

  Future<void> askForPermission({
    required PermissionRequest request,
    required Function(String) onError,
    required Function() onSuccess,
  }) async {
    emit(state.copyWith(createStatus: BlocStatus.loading));
    final result = await response(request: _api.askForPermission(request));

    result.fold(
      (l) {
        onError.call(l.message);

        emit(state.copyWith(createStatus: BlocStatus.error));
      },
      (r) {
        getPermissions(status: PermissionStatus.PENDING, page: 1);
        emit(
          state.copyWith(
            createStatus: BlocStatus.success,
            permissionStatus: PermissionStatus.PENDING,
          ),
        );
        onSuccess.call();
      },
    );
  }

  Future<void> updatePermission({
    required String id,
    required PermissionRequest request,
    required Function(String) onError,
    required Function() onSuccess,
  }) async {
    emit(state.copyWith(createStatus: BlocStatus.loading));
    final result = await response(
      request: _api.updatePermission(id: id, request: request),
    );

    result.fold(
      (l) {
        emit(state.copyWith(createStatus: BlocStatus.error));
        onError.call(l.message);
      },
      (r) {
        getPermissions();
        onSuccess.call();

        emit(state.copyWith(createStatus: BlocStatus.success));
      },
    );
  }

  Future<void> deletePermission(
    String id, {
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    emit(state.copyWith(createStatus: BlocStatus.loading));

    final result = await response(request: _api.deletePermission(id));

    result.fold(
      (l) {
        emit(state.copyWith(createStatus: BlocStatus.error));

        onError.call(l.message);
      },
      (r) {
        getPermissions();

        onSuccess.call();
        emit(state.copyWith(createStatus: BlocStatus.success));
      },
    );
  }

  Future<void> getReasons() async {
    final result = await response(request: _api.getReasons());
    result.fold((l) {}, (r) {
      emit(state.copyWith(reasons: r));
    });
  }
}
