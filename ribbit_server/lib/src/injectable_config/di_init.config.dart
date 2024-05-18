// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../app/controller/user_controller.dart' as _i7;
import '../app/repository/impl/user_repository_impl.dart' as _i4;
import '../app/repository/user_repository.dart' as _i3;
import '../app/service/impl/user_service_impl.dart' as _i6;
import '../app/service/user_service.dart' as _i5;

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
    gh.singleton<_i3.UserRepository>(() => _i4.UserRepositoryImpl());
    gh.singleton<_i5.UserService>(
        () => _i6.UserServiceImpl(userRepository: gh<_i3.UserRepository>()));
    gh.singleton<_i7.UserController>(
        () => _i7.UserController(userService: gh<_i5.UserService>()));
    return this;
  }
}
