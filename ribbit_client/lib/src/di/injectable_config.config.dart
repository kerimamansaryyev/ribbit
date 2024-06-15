// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i3;

import '../core/rest_client/auth_interceptor.dart' as _i5;
import '../core/storage/auth_storage.dart' as _i4;
import 'third_party_injection_module.dart' as _i7;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final thirdPartyInjectionModule = _$ThirdPartyInjectionModule();
    gh.singletonAsync<_i3.SharedPreferences>(
        () => thirdPartyInjectionModule.sharedPreferences);
    gh.singletonAsync<_i4.AuthStorage>(() async =>
        _i4.AuthStorageImpl(await getAsync<_i3.SharedPreferences>()));
    gh.factoryAsync<_i5.AuthInterceptor>(
        () async => _i5.AuthInterceptor(await getAsync<_i4.AuthStorage>()));
    gh.factoryAsync<_i6.Dio>(() async => thirdPartyInjectionModule
        .dioClient(await getAsync<_i5.AuthInterceptor>()));
    return this;
  }
}

class _$ThirdPartyInjectionModule extends _i7.ThirdPartyInjectionModule {}
