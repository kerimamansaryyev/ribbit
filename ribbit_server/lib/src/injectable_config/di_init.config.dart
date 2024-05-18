// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../app/controller/user_controller.dart' as _i6;
import '../app/service/impl/user_service_impl.dart' as _i5;
import '../app/service/user_service.dart' as _i4;
import '../prisma/generated/client.dart' as _i3;
import 'register_module.dart' as _i7;

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
    await gh.singletonAsync<_i3.PrismaClient>(
      () => registerModule.prismaClient(),
      preResolve: true,
    );
    gh.singleton<_i4.UserService>(
        () => _i5.UserServiceImpl(prismaClient: gh<_i3.PrismaClient>()));
    gh.singleton<_i6.UserController>(
        () => _i6.UserController(userService: gh<_i4.UserService>()));
    return this;
  }
}

class _$RegisterModule extends _i7.RegisterModule {}
