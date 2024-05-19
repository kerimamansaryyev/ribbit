// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dotenv/dotenv.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../app/controller/reminder_controller.dart' as _i15;
import '../app/controller/user_controller.dart' as _i14;
import '../app/integration/impl/jwt_authenticator_impl.dart' as _i9;
import '../app/integration/jwt_authenticator.dart' as _i8;
import '../app/repository/impl/reminder_repository_impl.dart' as _i7;
import '../app/repository/impl/user_repository_impl.dart' as _i5;
import '../app/repository/reminder_repository.dart' as _i6;
import '../app/repository/user_repository.dart' as _i4;
import '../app/service/impl/reminder_service_impl.dart' as _i13;
import '../app/service/impl/user_service_impl.dart' as _i11;
import '../app/service/reminder_service.dart' as _i12;
import '../app/service/user_service.dart' as _i10;
import 'register_module.dart' as _i16;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i3.DotEnv>(() => registerModule.dotEnv);
    gh.singleton<_i4.UserRepository>(() => _i5.UserRepositoryImpl());
    gh.singleton<_i6.ReminderRepository>(() => _i7.ReminderRepositoryImpl());
    await gh.singletonAsync<_i8.JWTAuthenticator>(
      () => _i9.JWTAuthenticatorImpl.init(gh<_i3.DotEnv>()),
      preResolve: true,
    );
    gh.singleton<_i10.UserService>(() => _i11.UserServiceImpl(
          gh<_i8.JWTAuthenticator>(),
          gh<_i4.UserRepository>(),
        ));
    gh.singleton<_i12.ReminderService>(
        () => _i13.ReminderServiceImpl(gh<_i6.ReminderRepository>()));
    gh.singleton<_i14.UserController>(
        () => _i14.UserController(gh<_i10.UserService>()));
    gh.singleton<_i15.ReminderController>(
        () => _i15.ReminderController(gh<_i12.ReminderService>()));
    return this;
  }
}

class _$RegisterModule extends _i16.RegisterModule {}
