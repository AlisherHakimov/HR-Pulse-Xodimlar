// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hr_plus/core/network/network_info.dart' as _i299;
import 'package:hr_plus/data/api/auth_api.dart' as _i578;
import 'package:hr_plus/data/api/profile_api.dart' as _i70;
import 'package:hr_plus/data/dio/dio_module.dart' as _i257;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final internetModule = _$InternetModule();
    final dioModule = _$DioModule();
    gh.lazySingleton<_i973.InternetConnectionChecker>(
      () => internetModule.internetConnectionChecker,
    );
    gh.factory<String>(() => dioModule.host, instanceName: 'Host');
    gh.factory<String>(() => dioModule.testHost, instanceName: 'TestHost');
    gh.factory<bool>(() => dioModule.isTest, instanceName: 'Environment');
    gh.singletonAsync<_i361.Dio>(
      () => dioModule.getAuthorizedDioClient(
        isTest: gh<bool>(instanceName: 'Environment'),
        host: gh<String>(instanceName: 'Host'),
        testHost: gh<String>(instanceName: 'TestHost'),
      ),
    );
    gh.singletonAsync<_i361.Dio>(
      () => dioModule.getUnauthorizedDioClient(
        isTest: gh<bool>(instanceName: 'Environment'),
        host: gh<String>(instanceName: 'Host'),
        testHost: gh<String>(instanceName: 'TestHost'),
      ),
      instanceName: 'UnauthorizedClient',
    );
    gh.singletonAsync<_i578.AuthApi>(
      () async => _i578.AuthApi.new(await getAsync<_i361.Dio>()),
    );
    gh.singletonAsync<_i70.ProfileApi>(
      () async => _i70.ProfileApi.new(await getAsync<_i361.Dio>()),
    );
    return this;
  }
}

class _$InternetModule extends _i299.InternetModule {}

class _$DioModule extends _i257.DioModule {}
