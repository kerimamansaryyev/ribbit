// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dotenv/dotenv.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i5;

import '../app/controller/reminder_controller.dart' as _i20;
import '../app/controller/user_controller.dart' as _i19;
import '../app/integration/impl/jwt_authenticator_impl.dart' as _i12;
import '../app/integration/impl/ribbit_notification_scheduler_service_delegate_impl.dart'
    as _i14;
import '../app/integration/jwt_authenticator.dart' as _i11;
import '../app/integration/ribbit_notification_scheduler_service_delegate.dart'
    as _i13;
import '../app/repository/impl/reminder_repository_impl.dart' as _i10;
import '../app/repository/impl/user_repository_impl.dart' as _i8;
import '../app/repository/reminder_repository.dart' as _i9;
import '../app/repository/user_repository.dart' as _i7;
import '../app/service/impl/reminder_service_impl.dart' as _i18;
import '../app/service/impl/user_service_impl.dart' as _i16;
import '../app/service/reminder_service.dart' as _i17;
import '../app/service/user_service.dart' as _i15;
import '../app/utils/http_client_request_delegate.dart' as _i6;
import 'register_module.dart' as _i21;

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
    gh.factory<_i3.Client>(() => registerModule.client);
    gh.singleton<_i4.DotEnv>(() => registerModule.dotEnv);
    gh.singleton<_i5.Logger>(() => registerModule.logger);
    gh.factory<_i6.HttpClientRequestDelegate>(
        () => _i6.HttpClientRequestDelegate(gh<_i3.Client>()));
    gh.singleton<_i7.UserRepository>(() => _i8.UserRepositoryImpl());
    gh.singleton<_i9.ReminderRepository>(() => _i10.ReminderRepositoryImpl());
    await gh.singletonAsync<_i11.JWTAuthenticator>(
      () => _i12.JWTAuthenticatorImpl.init(gh<_i4.DotEnv>()),
      preResolve: true,
    );
    await gh.singletonAsync<_i13.RibbitNotificationSchedulerServiceDelegate>(
      () => _i14.RibbitNotificationSchedulerServiceDelegateImpl.init(
        gh<_i6.HttpClientRequestDelegate>(),
        gh<_i4.DotEnv>(),
        gh<_i5.Logger>(),
      ),
      preResolve: true,
    );
    gh.singleton<_i15.UserService>(() => _i16.UserServiceImpl(
          gh<_i11.JWTAuthenticator>(),
          gh<_i7.UserRepository>(),
          gh<_i13.RibbitNotificationSchedulerServiceDelegate>(),
        ));
    gh.singleton<_i17.ReminderService>(() => _i18.ReminderServiceImpl(
          gh<_i9.ReminderRepository>(),
          gh<_i13.RibbitNotificationSchedulerServiceDelegate>(),
        ));
    gh.singleton<_i19.UserController>(
        () => _i19.UserController(gh<_i15.UserService>()));
    gh.singleton<_i20.ReminderController>(
        () => _i20.ReminderController(gh<_i17.ReminderService>()));
    return this;
  }
}

class _$RegisterModule extends _i21.RegisterModule {}
