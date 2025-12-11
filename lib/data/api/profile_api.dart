import 'package:dio/dio.dart';
import 'package:hr_plus/data/model/Attendance_model.dart';
import 'package:hr_plus/data/model/action_model.dart';
import 'package:hr_plus/data/model/notification_model.dart';
import 'package:hr_plus/data/model/notifications_response.dart';
import 'package:hr_plus/data/model/permission_model.dart';
import 'package:hr_plus/data/model/permissions_response.dart';
import 'package:hr_plus/data/model/reason_model.dart';
import 'package:hr_plus/data/model/report_model.dart';
import 'package:hr_plus/data/model/request/permission_request.dart';
import 'package:hr_plus/data/model/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api.g.dart';

@RestApi()
@Singleton()
abstract class ProfileApi {
  @factoryMethod
  factory ProfileApi(Dio dio) = _ProfileApi;

  @GET('/employees/me')
  Future<UserModel> getMe();

  @GET('/employees/me/attendance')
  Future<List<AttendanceModel>> getAttendance({
    @Query('year') int? year,
    @Query('month') int? month,
  });

  @GET('/attendances/{id}/outsides')
  Future<List<ActionModel>> getDailyActions({@Path('id') required String id});

  @GET('/transactions/')
  Future<List<ReportModel>> getReports({
    @Query('created_at_start') String? createdAtStart,
    @Query('created_at_end') String? createdAtEnd,
  });

  @GET('/employees/schedule_requests/')
  Future<PermissionsResponse> getPermissions({
    @Query('status') String? status,
    @Query('page') int? page,
  });

  @GET('/employees/schedule_requests/{id}')
  Future<PermissionModel> getPermissionById(@Path('id') String id);

  @POST('/employees/schedule_requests/')
  Future<PermissionModel> askForPermission(@Body() PermissionRequest request);

  @PATCH('/employees/schedule_requests/{id}/')
  Future<PermissionModel> updatePermission({
    @Path('id') required String id,
    @Body() required PermissionRequest request,
  });

  @DELETE('/employees/schedule_requests/{id}/')
  Future<dynamic> deletePermission(@Path('id') String id);

  @GET('/reasons')
  Future<List<ReasonModel>> getReasons();

  @GET('/notifications')
  Future<NotificationsResponse> getNotifications({@Query('page') int? page});

  @GET('/notifications/{id}')
  Future<NotificationModel> readNotification(@Path() String id);

  @POST('/notifications/mark_all_as_read')
  Future<dynamic> readAllNotifications();
}
