import 'package:dio/dio.dart';
import 'package:hr_plus/data/model/auth_model.dart';
import 'package:hr_plus/data/model/register_model.dart';
import 'package:hr_plus/data/model/success_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
@Singleton()
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(Dio dio) = _AuthApi;

  @FormUrlEncoded()
  @POST('/employees/auth/login')
  Future<AuthModel> loginUser({
    @Field("phone_number") required String phoneNumber,
    @Field() required String password,
  });

  @FormUrlEncoded()
  @POST('/auth/reset_password/request/')
  Future<RegisterModel> resetPassword({
    @Field("phone_number") required String phoneNumber,
  });

  @FormUrlEncoded()
  @POST('/auth/reset_password/{id}/resend/')
  Future<SuccessModel> resetPasswordResendOtp({
    @Path('id') required String sessionId,
    @Field('phone_number') required String phoneNumber,
  });

  @FormUrlEncoded()
  @POST('/auth/reset_password/{id}/verify/')
  Future<AuthModel> resetPasswordVerifyUser({
    @Path('id') required String sessionId,
    @Field('otp') required int otp,
  });

  @FormUrlEncoded()
  @POST('/auth/change_password')
  Future<AuthModel> changePassword({
    @Field('reset_password') required String sessionId,
    @Field('new_password') required String newPassword,
  });

  @FormUrlEncoded()
  @PATCH('/employees/auth/session')
  Future<AuthModel> updateFcm({
    @Field('fcm_token') required String fcmToken,
    @Field('lang') required String lang,
  });
}
