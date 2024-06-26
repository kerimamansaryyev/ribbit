// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i6;

import '../core/blocs/global_inter_layer_conversation_bloc.dart' as _i7;
import '../core/rest_client/intercepted_rest_client.dart' as _i3;
import '../core/rest_client/rest_client.dart' as _i8;
import '../features/auth/data/interceptor/token_interceptor.dart' as _i5;
import 'third_party_injection_module.dart' as _i9;

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
    gh.factoryParam<_i3.InterceptedRestClient,
        _i3.InterceptedRestClientFactoryParam, dynamic>((
      param,
      _,
    ) =>
        _i3.InterceptedRestClient.internal(
          gh<_i4.Dio>(),
          param,
        ));
    gh.factory<_i4.Dio>(() => thirdPartyInjectionModule.dioClient);
    gh.factory<_i5.TokenInterceptor>(() => _i5.TokenInterceptor());
    gh.singletonAsync<_i6.SharedPreferences>(
        () => thirdPartyInjectionModule.sharedPreferences);
    gh.lazySingleton<_i7.GlobalInterLayerConversationBloc>(
        () => _i7.GlobalInterLayerConversationBloc());
    gh.factory<_i8.BaseRestClient>(() => _i8.BaseRestClient(gh<_i4.Dio>()));
    return this;
  }
}

class _$ThirdPartyInjectionModule extends _i9.ThirdPartyInjectionModule {}
