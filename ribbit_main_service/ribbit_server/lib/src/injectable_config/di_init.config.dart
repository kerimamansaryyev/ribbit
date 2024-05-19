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

import '../app/controller/reminder_controller.dart' as _i16;
import '../app/controller/user_controller.dart' as _i17;
import '../app/integration/impl/jwt_authenticator_impl.dart' as _i11;
import '../app/integration/impl/reminder_scheduler_impl.dart' as _i5;
import '../app/integration/jwt_authenticator.dart' as _i10;
import '../app/integration/reminder_scheduler.dart' as _i4;
import '../app/repository/impl/reminder_repository_impl.dart' as _i9;
import '../app/repository/impl/user_repository_impl.dart' as _i7;
import '../app/repository/reminder_repository.dart' as _i8;
import '../app/repository/user_repository.dart' as _i6;
import '../app/service/impl/reminder_service_impl.dart' as _i15;
import '../app/service/impl/user_service_impl.dart' as _i13;
import '../app/service/reminder_service.dart' as _i14;
import '../app/service/user_service.dart' as _i12;
import 'register_module.dart' as _i18;

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
    gh.singleton<_i4.ReminderScheduler>(() => _i5.ReminderSchedulerImpl());
    gh.singleton<_i6.UserRepository>(() => _i7.UserRepositoryImpl());
    gh.singleton<_i8.ReminderRepository>(() => _i9.ReminderRepositoryImpl());
    await gh.singletonAsync<_i10.JWTAuthenticator>(
      () => _i11.JWTAuthenticatorImpl.init(gh<_i3.DotEnv>()),
      preResolve: true,
    );
    gh.singleton<_i12.UserService>(() => _i13.UserServiceImpl(
          gh<_i10.JWTAuthenticator>(),
          gh<_i6.UserRepository>(),
        ));
    gh.singleton<_i14.ReminderService>(() => _i15.ReminderServiceImpl(
          gh<_i8.ReminderRepository>(),
          gh<_i4.ReminderScheduler>(),
        )..init());
    gh.singleton<_i16.ReminderController>(
        () => _i16.ReminderController(gh<_i14.ReminderService>()));
    gh.singleton<_i17.UserController>(
        () => _i17.UserController(gh<_i12.UserService>()));
    return this;
  }
}

class _$RegisterModule extends _i18.RegisterModule {}
