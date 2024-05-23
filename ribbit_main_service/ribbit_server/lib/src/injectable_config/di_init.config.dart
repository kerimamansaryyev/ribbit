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
import 'package:logger/logger.dart' as _i4;

import '../app/controller/reminder_controller.dart' as _i16;
import '../app/controller/user_controller.dart' as _i15;
import '../app/integration/impl/jwt_authenticator_impl.dart' as _i10;
import '../app/integration/jwt_authenticator.dart' as _i9;
import '../app/repository/impl/reminder_repository_impl.dart' as _i8;
import '../app/repository/impl/user_repository_impl.dart' as _i6;
import '../app/repository/reminder_repository.dart' as _i7;
import '../app/repository/user_repository.dart' as _i5;
import '../app/service/impl/reminder_service_impl.dart' as _i14;
import '../app/service/impl/user_service_impl.dart' as _i12;
import '../app/service/reminder_service.dart' as _i13;
import '../app/service/user_service.dart' as _i11;
import 'register_module.dart' as _i17;

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
    gh.singleton<_i4.Logger>(() => registerModule.logger);
    gh.singleton<_i5.UserRepository>(() => _i6.UserRepositoryImpl());
    gh.singleton<_i7.ReminderRepository>(() => _i8.ReminderRepositoryImpl());
    await gh.singletonAsync<_i9.JWTAuthenticator>(
      () => _i10.JWTAuthenticatorImpl.init(gh<_i3.DotEnv>()),
      preResolve: true,
    );
    gh.singleton<_i11.UserService>(() => _i12.UserServiceImpl(
          gh<_i9.JWTAuthenticator>(),
          gh<_i5.UserRepository>(),
        ));
    gh.singleton<_i13.ReminderService>(
        () => _i14.ReminderServiceImpl(gh<_i7.ReminderRepository>()));
    gh.singleton<_i15.UserController>(
        () => _i15.UserController(gh<_i11.UserService>()));
    gh.singleton<_i16.ReminderController>(
        () => _i16.ReminderController(gh<_i13.ReminderService>()));
    return this;
  }
}

class _$RegisterModule extends _i17.RegisterModule {}
